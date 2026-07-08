const app = Vue.createApp({
    data() {
        return {
            display: false,
            joinPartyId: false,
            requestPopup: false,
            shortcutDisplay: false,
            isInputFocused: false,

            showShortcutDisplayAllTheTime: false,

            imagePath: 'nui://zobyeteam_inventory/interface/image/items/water.png',

            partyType: 'private',

            searchParty: '',

            isHeader: false,
            myId: 0,
            maxExp: 0,
            targetGive: null,

            // Gang Info
            nameInput: '',
            isHidePassword: true,
            passwordInput: '',

            messageInput: '',

            partyList: [],

            myParty: null,

            openEmojiPicker: false,
        }
    },
    computed: {
        parties() {
            return this.partyList.filter(item => item.name?.toLowerCase().includes(this.searchParty?.toLowerCase()))
        }
    },
    methods: {
        getMessageDetails(item, index) {
            let chat = this.myParty.chat;
            let css = 'text-[#D3D3D3] bg-[#333333] rounded-t-[1.1em] rounded-bl-[0.2em] rounded-br-[1.1em]';

            let isMe = item.senderId == this.myId;

            if (isMe) {
                css = 'text-white bg-[#00A3FF] rounded-t-[1.1em] rounded-bl-[1.1em] rounded-br-[0.2em]';
            }

            if (index != 0 && chat[index + 1] && chat[index + 1].senderId == item.senderId && chat[index - 1].senderId == item.senderId) {
                css = isMe ? 'text-white bg-[#00A3FF] rounded-tl-[1.1em] rounded-tr-[0.2em] rounded-bl-[1.1em] rounded-br-[0.2em]' : 'text-[#D3D3D3] bg-[#333333] rounded-tl-[0.2em] rounded-tr-[1.1em] rounded-bl-[0.2em] rounded-br-[1.1em]'
            } else if (chat[index + 1] && chat[index + 1].senderId == item.senderId) {
                css = isMe ? 'text-white bg-[#00A3FF] rounded-tl-[1.1em] rounded-tr-[0.2em] rounded-b-[1.1em]' : 'text-[#D3D3D3] bg-[#333333] rounded-tr-[1.1em] rounded-tl-[0.2em] rounded-b-[1.1em]'
            }

            return css;
        },
        upperCase(str) {
            return str ? str.toUpperCase() : '';
        },
        selectParty(item) {
            if (this.myParty) {
                navigator.sendBeacon('https://zobyeteam_party/alreadyHaveParty');
            } else if (item.public) {
                this.requestPopup = 'public';
                this.joinPartyId = item.id;
            } else {
                this.requestPopup = 'private';
                this.joinPartyId = item.id;
            }
        },
        createParty() {
            navigator.sendBeacon('https://zobyeteam_party/createParty', JSON.stringify({
                name: this.nameInput,
                password: this.passwordInput,
                public: this.partyType == 'public'
            }));

            this.nameInput = '';
            this.passwordInput = '';
        },
        joinParty() {
            navigator.sendBeacon('https://zobyeteam_party/joinParty', JSON.stringify({
                targetId: this.joinPartyId,
                password: this.passwordInput,
            }));

            this.joinPartyId = false;
            this.passwordInput = '';
        },
        changeTargetGive(targetId) {
            navigator.sendBeacon('https://zobyeteam_party/changeTargetGive', JSON.stringify({ targetId }));
        },
        kickMember(targetId) {
            navigator.sendBeacon('https://zobyeteam_party/kickOff', JSON.stringify({ targetId }));
        },
        invitePlayer() {
            navigator.sendBeacon('https://zobyeteam_party/invitePlayer');
        },
        disbandParty() {
            navigator.sendBeacon('https://zobyeteam_party/disbandParty');
        },
        leaveParty() {
            navigator.sendBeacon('https://zobyeteam_party/leaveParty');
        },
        sendMessage() {
            if (!this.messageInput) return;

            navigator.sendBeacon('https://zobyeteam_party/sendMessage', JSON.stringify({ 
                message: this.messageInput,
            }));

            this.messageInput = '';
            this.openEmojiPicker = false;
        },
        sendRequest() {
            navigator.sendBeacon('https://zobyeteam_party/sendRequest', JSON.stringify({ targetId : this.joinPartyId }));
        },
        acceptRequest(targetId) {
            navigator.sendBeacon('https://zobyeteam_party/acceptRequest', JSON.stringify({ targetId }));
        },
        declineRequest(targetId) {
            navigator.sendBeacon('https://zobyeteam_party/declineRequest', JSON.stringify({ targetId }));
        },
        onInputFocus() {
            this.isInputFocused = true;
        },
        onInputBlur() {
            this.isInputFocused = false;
        }
    },
    watch: {
        display(value) {
            if (value !== 'chat') {
                this.openEmojiPicker = false;
            }
        },
        partyType(value) {
            if (value === 'public') {
                this.passwordInput = '';
            }
        }
    },
    mounted() {
        const container = document.querySelector('#pickerContainer');
        const picker = picmo.createPicker({
            rootElement: container,
            theme: picmo.darkTheme,
            className: 'my-picker',
            showPreview: false,
            // showVariants: false,
            emojiSize: '1.5rem',
            emojisPerRow: 10,
            visibleRows: 6
        });

        picker.addEventListener('emoji:select', (e) => {
            this.messageInput = `${this.messageInput}${e.emoji}`
        })
    },
}).mount('.wrapper')

window.addEventListener('message', ({ data }) => {
    if (data.action === 'loadData') {
        if (data.type === 'myParty') {
            app.showShortcutDisplayAllTheTime = data.showShortcutDisplayAllTheTime;

            app.imagePath = data.imagePath;

            app.isHeader = data.isHeader;
            app.myId = data.myId;
    
            app.myParty = data.myParty;
            app.maxExp = data.maxExp;

            if (!app.myParty) {
                app.shortcutDisplay = false;
            }

            if (app.myParty) app.myParty.chat.reverse();
        } else if (data.type === 'partyList') {
            app.partyList = data.partyList;
        }
    } else if (data.action === 'openDisplay') {
        app.display = 'home';

        if (app.myParty) {
            app.shortcutDisplay = false;
        }
    } else if (data.action === 'closeDisplay') {
        app.display = false;
        app.joinPartyId = false;
        app.requestPopup = false;

        if (app.myParty && app.showShortcutDisplayAllTheTime) {
            app.shortcutDisplay = true;
        }
    } else if (data.action === 'sendRequest') {
        app.joinPartyId = false;
    } else if (data.action === 'changeTargetGive') {
        app.targetGive = data.targetGive;
    } else if (data.action === 'togglePartyShortcut') {
        app.showShortcutDisplayAllTheTime = data.isShowPartyShortcut;
        if (app.myParty && app.showShortcutDisplayAllTheTime && !app.display) {
            app.shortcutDisplay = true;
        } else if (!app.showShortcutDisplayAllTheTime) {
            app.shortcutDisplay = false;
        }
    }
});

window.addEventListener('keydown', ({ key }) => {
    if (key === 'Escape') {
        navigator.sendBeacon('https://zobyeteam_party/closeDisplay');
    } else if (key === 'Enter') {
        if (!app.isInputFocused) return;

        app.sendMessage();
    }
});
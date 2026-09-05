/**
 * Blockventure - Core Game Engine
 * Supports: Lobby, Shop, Upgrades, Achievements, Leaderboard, Classic & Adventure Modes.
 */

// Shape Definitions
const SHAPES = [
    // Dots & Lines
    { matrix: [[1]], color: 'c-amber', name: 'dot' },
    { matrix: [[1, 1]], color: 'c-cyan', name: 'h2' },
    { matrix: [[1], [1]], color: 'c-cyan', name: 'v2' },
    { matrix: [[1, 1, 1]], color: 'c-blue', name: 'h3' },
    { matrix: [[1], [1], [1]], color: 'c-blue', name: 'v3' },
    { matrix: [[1, 1, 1, 1]], color: 'c-purple', name: 'h4' },
    { matrix: [[1], [1], [1], [1]], color: 'c-purple', name: 'v4' },
    { matrix: [[1, 1, 1, 1, 1]], color: 'c-pink', name: 'h5' },
    { matrix: [[1], [1], [1], [1], [1]], color: 'c-pink', name: 'v5' },

    // Squares
    { matrix: [[1, 1], [1, 1]], color: 'c-green', name: 'sq2' },
    { matrix: [[1, 1, 1], [1, 1, 1], [1, 1, 1]], color: 'c-red', name: 'sq3' },

    // Corners (2x2)
    { matrix: [[1, 1], [1, 0]], color: 'c-orange', name: 'c2_tl' },
    { matrix: [[1, 1], [0, 1]], color: 'c-orange', name: 'c2_tr' },
    { matrix: [[1, 0], [1, 1]], color: 'c-orange', name: 'c2_bl' },
    { matrix: [[0, 1], [1, 1]], color: 'c-orange', name: 'c2_br' },

    // Corners / L-Shapes (3x3)
    { matrix: [[1, 0, 0], [1, 0, 0], [1, 1, 1]], color: 'c-amber', name: 'l3_bl' },
    { matrix: [[0, 0, 1], [0, 0, 1], [1, 1, 1]], color: 'c-amber', name: 'l3_br' },
    { matrix: [[1, 1, 1], [1, 0, 0], [1, 0, 0]], color: 'c-amber', name: 'l3_tl' },
    { matrix: [[1, 1, 1], [0, 0, 1], [0, 0, 1]], color: 'c-amber', name: 'l3_tr' },

    // Z and S Shapes
    { matrix: [[1, 1, 0], [0, 1, 1]], color: 'c-red', name: 'z_h' },
    { matrix: [[0, 1, 1], [1, 1, 0]], color: 'c-green', name: 's_h' },
    { matrix: [[1, 0], [1, 1], [0, 1]], color: 'c-red', name: 'z_v' },
    { matrix: [[0, 1], [1, 1], [1, 0]], color: 'c-green', name: 's_v' },

    // Rectangles & Plus
    { matrix: [[1, 1, 1], [1, 1, 1]], color: 'c-blue', name: 'rect_3x2' },
    { matrix: [[1, 1], [1, 1], [1, 1]], color: 'c-blue', name: 'rect_2x3' },
    { matrix: [[0, 1, 0], [1, 1, 1], [0, 1, 0]], color: 'c-cyan', name: 'plus' }
];

// Themes
const THEMES = [
    { id: 'neon', name: 'Neon Cyber', price: 0, swatches: ['#06b6d4', '#8b5cf6', '#ec4899', '#10b981'] },
    { id: 'gems', name: 'Kristály Drágakő', price: 300, swatches: ['#38bdf8', '#6366f1', '#c084fc', '#f43f5e'] },
    { id: 'retro', name: 'Retro 8-Bit', price: 600, swatches: ['#00f0ff', '#ff0077', '#ffff00', '#00ff66'] },
    { id: 'candy', name: 'Candy Édesség', price: 900, swatches: ['#67e8f9', '#d8b4fe', '#f9a8d4', '#fed7aa'] },
    { id: 'gold', name: 'Arany Deluxe', price: 1500, swatches: ['#fef08a', '#fbbf24', '#f59e0b', '#d97706'] }
];

// Upgrades (Adventure Mode Only)
const UPGRADES_DEF = [
    { 
        id: 'extraMoves', 
        name: 'Kezdőlépések (+1 Lépés)', 
        icon: '⏳', 
        maxLvl: 50, 
        baseCost: 50, 
        desc: 'Minden szint növeli a Kaland mód kezdő lépésszámát +1 lépéssel (Alap: 10).' 
    },
    { 
        id: 'skipChance', 
        name: 'Lépésmegtartás Esély (+0.2%)', 
        icon: '🎲', 
        maxLvl: 100, 
        baseCost: 80, 
        desc: 'Minden szinttel +0.2%-kal nő az esély, hogy lerakáskor nem vesztesz lépést (Ingyen lépés).' 
    }
];

// Mastery Ranks
const MASTERY_RANKS = [
    { name: 'Kezdő Blaszter', icon: '🌱', minXp: 0, maxXp: 150 },
    { name: 'Bronz Romboló', icon: '🥉', minXp: 150, maxXp: 400 },
    { name: 'Ezüst Taktikus', icon: '🥈', minXp: 400, maxXp: 850 },
    { name: 'Arany Bajnok', icon: '🥇', minXp: 850, maxXp: 1600 },
    { name: 'Gyémánt Mester', icon: '💎', minXp: 1600, maxXp: 2800 },
    { name: 'Kozmikus Titán', icon: '🔮', minXp: 2800, maxXp: 5000 },
    { name: 'Végtelen Legenda', icon: '👑', minXp: 5000, maxXp: 999999 }
];

function getRomanNumeral(num) {
    const romanMap = [
        [1000, 'M'], [900, 'CM'], [500, 'D'], [400, 'CD'],
        [100, 'C'], [90, 'XC'], [50, 'L'], [40, 'XL'],
        [10, 'X'], [9, 'IX'], [5, 'V'], [4, 'IV'], [1, 'I']
    ];
    let res = '';
    for (const [val, letter] of romanMap) {
        while (num >= val) {
            res += letter;
            num -= val;
        }
    }
    return res || 'I';
}

// Simulated Competitors for Leaderboard & Profile Previews
const SIMULATED_CLASSIC_LEADERBOARD = [
    { 
        name: 'NeonKing', 
        score: 12650, 
        rank: 1, 
        icon: '👑', 
        rankTitle: 'Végtelen Legenda', 
        rankIcon: '👑', 
        rankLevel: 7, 
        achCount: 24, 
        blocks: 4820, 
        lines: 940, 
        maxCombo: 12, 
        coins: 18500 
    },
    { 
        name: 'BlasterPro', 
        score: 8420, 
        rank: 2, 
        icon: '⚡', 
        rankTitle: 'Kozmikus Titán', 
        rankIcon: '🔮', 
        rankLevel: 6, 
        achCount: 19, 
        blocks: 3210, 
        lines: 620, 
        maxCombo: 9, 
        coins: 11400 
    },
    { 
        name: 'CubeMaster', 
        score: 6890, 
        rank: 3, 
        icon: '🎲', 
        rankTitle: 'Gyémánt Mester', 
        rankIcon: '💎', 
        rankLevel: 5, 
        achCount: 16, 
        blocks: 2540, 
        lines: 480, 
        maxCombo: 7, 
        coins: 8200 
    },
    { 
        name: 'CyberBlade', 
        score: 5410, 
        rank: 4, 
        icon: '🤖', 
        rankTitle: 'Arany Bajnok', 
        rankIcon: '🥇', 
        rankLevel: 4, 
        achCount: 12, 
        blocks: 1980, 
        lines: 390, 
        maxCombo: 6, 
        coins: 6100 
    },
    { 
        name: 'PixelHero', 
        score: 4190, 
        rank: 5, 
        icon: '👾', 
        rankTitle: 'Ezüst Taktikus', 
        rankIcon: '🥈', 
        rankLevel: 3, 
        achCount: 9, 
        blocks: 1450, 
        lines: 280, 
        maxCombo: 5, 
        coins: 3900 
    },
    { 
        name: 'GridRunner', 
        score: 3280, 
        rank: 6, 
        icon: '🦊', 
        rankTitle: 'Bronz Romboló', 
        rankIcon: '🥉', 
        rankLevel: 2, 
        achCount: 6, 
        blocks: 1120, 
        lines: 210, 
        maxCombo: 4, 
        coins: 2400 
    }
];

const SIMULATED_ADVENTURE_LEADERBOARD = [
    { 
        name: 'GalaxyMaster', 
        score: 16840, 
        rank: 1, 
        icon: '🌌', 
        rankTitle: 'Végtelen Legenda', 
        rankIcon: '👑', 
        rankLevel: 7, 
        achCount: 24, 
        blocks: 5600, 
        lines: 1120, 
        maxCombo: 14, 
        coins: 24500 
    },
    { 
        name: 'TitanCrusher', 
        score: 12450, 
        rank: 2, 
        icon: '🛡️', 
        rankTitle: 'Kozmikus Titán', 
        rankIcon: '🔮', 
        rankLevel: 6, 
        achCount: 21, 
        blocks: 4300, 
        lines: 890, 
        maxCombo: 11, 
        coins: 16800 
    },
    { 
        name: 'StarExplorer', 
        score: 9890, 
        rank: 3, 
        icon: '🚀', 
        rankTitle: 'Gyémánt Mester', 
        rankIcon: '💎', 
        rankLevel: 5, 
        achCount: 18, 
        blocks: 3600, 
        lines: 710, 
        maxCombo: 9, 
        coins: 13200 
    },
    { 
        name: 'OrbHunter', 
        score: 7650, 
        rank: 4, 
        icon: '🔮', 
        rankTitle: 'Arany Bajnok', 
        rankIcon: '🥇', 
        rankLevel: 4, 
        achCount: 14, 
        blocks: 2800, 
        lines: 530, 
        maxCombo: 7, 
        coins: 9100 
    },
    { 
        name: 'BlockKnight', 
        score: 5320, 
        rank: 5, 
        icon: '⚔️', 
        rankTitle: 'Ezüst Taktikus', 
        rankIcon: '🥈', 
        rankLevel: 3, 
        achCount: 10, 
        blocks: 1890, 
        lines: 360, 
        maxCombo: 6, 
        coins: 5400 
    },
    { 
        name: 'VoxelRider', 
        score: 3890, 
        rank: 6, 
        icon: '🏍️', 
        rankTitle: 'Bronz Romboló', 
        rankIcon: '🥉', 
        rankLevel: 2, 
        achCount: 7, 
        blocks: 1340, 
        lines: 260, 
        maxCombo: 4, 
        coins: 3100 
    }
];

// Achievements Catalog (Simplified: Lerakott kockák, Törölt sorok, Kombók)
const ACHIEVEMENTS_DEF = [
    {
        id: 'total_blocks_placed',
        mode: 'classic',
        title: 'Kocka Mester',
        icon: '🧩',
        desc: (target) => `Húzz be és rakj le összesen ${target.toLocaleString()} kockát a pályára.`,
        getStat: (p) => ((p.stats && p.stats.blocksPlaced) || 0) + ((p.stats && p.stats.advBlocksPlaced) || 0),
        getGoal: (tier) => Math.round(150 * Math.pow(1.5, tier - 1)),
        getRewardCoins: (tier) => 60 + tier * 35,
        getRewardXp: (tier) => 40 + tier * 25
    },
    {
        id: 'lines_cleared',
        mode: 'classic',
        title: 'Sor Romboló',
        icon: '💥',
        desc: (target) => `Törölj ki összesen ${target.toLocaleString()} teljes sort vagy oszlopot.`,
        getStat: (p) => (p.stats && p.stats.lines) || 0,
        getGoal: (tier) => Math.round(20 * Math.pow(1.5, tier - 1)),
        getRewardCoins: (tier) => 75 + tier * 40,
        getRewardXp: (tier) => 50 + tier * 30
    },
    {
        id: 'max_combo',
        mode: 'classic',
        title: 'Kombó Bajnok',
        icon: '🔥',
        desc: (target) => `Érj el legalább ${target}x láncreakció kombót.`,
        getStat: (p) => (p.stats && p.stats.combos) || 0,
        getGoal: (tier) => tier, // 1-ről indul és 1-essével növekszik
        getRewardCoins: (tier) => 80 + tier * 45,
        getRewardXp: (tier) => 60 + tier * 35
    }
];

class BlockBlasterApp {
    constructor() {
        this.boardSize = 8;
        this.loadProfile();

        this.gameMode = 'classic';
        this.grid = Array(8).fill(null).map(() => Array(8).fill(null));
        this.dockPieces = [null, null, null];
        this.score = 0;
        this.comboStreak = 0;
        this.sessionCoins = 0;
        this.sessionXp = 0;
        this.movesLeft = 0;

        this.draggedSlotIndex = null;
        this.draggedPiece = null;
        this.isDragging = false;
        this.touchOffsetY = 65;

        this.achCurrentTab = 'classic';
        this.lbCurrentTab = 'classic';

        this.initDOM();
        this.attachGlobalEvents();
        this.applyTheme(this.profile.equippedTheme);
        this.updateProfileUI();
        this.renderShop();
        this.renderUpgrades();
        this.renderAchievements();
        this.renderLeaderboard();
        this.updateLobbyMeta();
    }

    loadProfile() {
        const defaultProfile = {
            playerName: 'Játékos',
            avatarIcon: '🧑‍🚀',
            customAvatar: null,
            coins: 150, totalCoinsEarned: 150,
            classicBest: 0, adventureBest: 0, equippedTheme: 'neon',
            ownedThemes: ['neon'], upgrades: { extraMoves: 0, skipChance: 0 },
            stats: { lines: 0, combos: 0, blocksPlaced: 0, advBlocksPlaced: 0, coinsCollected: 0, maxCombo: 1, destroyedColors: {} },
            achievementTiers: {}, achievementXp: 0, claimedAchievementCount: 0, lastDailyClaim: null
        };
        const saved = localStorage.getItem('blockBlaster_profile');
        this.profile = saved ? Object.assign(defaultProfile, JSON.parse(saved)) : defaultProfile;
        if (!this.profile.playerName) this.profile.playerName = 'Játékos';
        if (!this.profile.avatarIcon) this.profile.avatarIcon = '🧑‍🚀';
    }

    saveProfile() {
        localStorage.setItem('blockBlaster_profile', JSON.stringify(this.profile));
        this.updateProfileUI();
        this.updateLobbyMeta();
    }

    addCoins(amount) {
        this.profile.coins += amount;
        this.profile.totalCoinsEarned += amount;
        if (!this.profile.stats) this.profile.stats = {};
        this.profile.stats.coinsCollected = (this.profile.stats.coinsCollected || 0) + amount;
        this.sessionCoins += amount;
        this.saveProfile();
        this.checkAchievements();
    }

    addXp(amount) {
        this.profile.achievementXp = (this.profile.achievementXp || 0) + amount;
        this.saveProfile();
        this.renderAchievementXpHero();
    }

    getMasteryRankInfo(achXp = (this.profile.achievementXp || 0)) {
        let currentRank = MASTERY_RANKS[0];
        let nextRank = MASTERY_RANKS[1];
        for (let i = 0; i < MASTERY_RANKS.length; i++) {
            if (achXp >= MASTERY_RANKS[i].minXp) {
                currentRank = MASTERY_RANKS[i];
                nextRank = MASTERY_RANKS[i + 1] || null;
            }
        }
        const rankIndex = MASTERY_RANKS.indexOf(currentRank) + 1;
        let pct = 100;
        let xpText = `${achXp} XP (MAX)`;
        if (nextRank) {
            const xpInLevel = achXp - currentRank.minXp;
            const xpNeeded = currentRank.maxXp - currentRank.minXp;
            pct = Math.min(100, Math.max(0, Math.round((xpInLevel / xpNeeded) * 100)));
            xpText = `${achXp} / ${currentRank.maxXp} XP`;
        }
        return {
            rank: currentRank,
            nextRank,
            rankIndex,
            romanLvl: rankIndex,
            name: currentRank.name,
            icon: currentRank.icon,
            pct,
            xpText
        };
    }

    getMyClassicRank() {
        const myScore = this.profile.classicBest || 0;
        for (let i = 0; i < SIMULATED_CLASSIC_LEADERBOARD.length; i++) {
            if (myScore > SIMULATED_CLASSIC_LEADERBOARD[i].score) {
                return i + 1;
            }
        }
        return SIMULATED_CLASSIC_LEADERBOARD.length + 1;
    }

    getMyAdventureRank() {
        const myScore = this.profile.adventureBest || 0;
        for (let i = 0; i < SIMULATED_ADVENTURE_LEADERBOARD.length; i++) {
            if (myScore > SIMULATED_ADVENTURE_LEADERBOARD[i].score) {
                return i + 1;
            }
        }
        return SIMULATED_ADVENTURE_LEADERBOARD.length + 1;
    }

    updateProfileUI() {
        const coinsEl = document.getElementById('player-coins');
        if (coinsEl) coinsEl.textContent = this.profile.coins;

        // Top bar avatar button info
        const topImg = document.getElementById('top-avatar-img');
        const topIcon = document.getElementById('top-avatar-icon');
        const topName = document.getElementById('top-player-name');
        const topRank = document.getElementById('top-player-rank-badge');

        if (topName) topName.textContent = this.profile.playerName || 'Játékos';

        const rankInfo = this.getMasteryRankInfo();
        if (topRank) topRank.textContent = `${rankInfo.icon} ${rankInfo.rankIndex}. Szint`;

        if (this.profile.customAvatar) {
            if (topImg) {
                topImg.src = this.profile.customAvatar;
                topImg.style.display = 'block';
            }
            if (topIcon) topIcon.style.display = 'none';
        } else {
            if (topImg) topImg.style.display = 'none';
            if (topIcon) {
                topIcon.textContent = this.profile.avatarIcon || '🧑‍🚀';
                topIcon.style.display = 'block';
            }
        }
    }

    updateLobbyMeta() {
        const classicEl = document.getElementById('lobby-classic-best');
        const advEl = document.getElementById('lobby-adventure-best');
        if (classicEl) classicEl.textContent = (this.profile.classicBest || 0).toLocaleString();
        if (advEl) advEl.textContent = (this.profile.adventureBest || 0).toLocaleString();
    }

    initDOM() {
        this.boardEl = document.getElementById('board');
        if (this.boardEl) {
            this.boardEl.innerHTML = '';
            for (let r = 0; r < this.boardSize; r++) {
                for (let c = 0; c < this.boardSize; c++) {
                    const cell = document.createElement('div');
                    cell.className = 'cell';
                    cell.dataset.row = r;
                    cell.dataset.col = c;
                    this.boardEl.appendChild(cell);
                }
            }
        }
        this.scoreEl = document.getElementById('current-score');
        this.highScoreEl = document.getElementById('high-score');
        this.comboBannerEl = document.getElementById('combo-banner');
        this.dockSlots = [document.getElementById('slot-0'), document.getElementById('slot-1'), document.getElementById('slot-2')];
        this.dragGhost = document.getElementById('drag-ghost');
        this.gameOverModal = document.getElementById('game-over-modal');
        this.adventureObjBar = document.getElementById('adventure-objective-bar');
        this.movesLeftDisplay = document.getElementById('moves-left-display');
        this.movesUpgradeInfo = document.getElementById('moves-upgrade-info');
        this.settingsModal = document.getElementById('settings-modal');
        this.initLobbyGridCanvas();
    }

    initLobbyGridCanvas() {
        const canvas = document.getElementById('lobby-grid-canvas');
        if (!canvas) return;
        const ctx = canvas.getContext('2d');
        if (!ctx) return;

        let width = 0;
        let height = 0;
        const dpr = Math.min(window.devicePixelRatio || 1, 2);

        const resize = () => {
            const rect = canvas.getBoundingClientRect();
            width = rect.width || window.innerWidth;
            height = rect.height || window.innerHeight;
            canvas.width = Math.floor(width * dpr);
            canvas.height = Math.floor(height * dpr);
            ctx.setTransform(dpr, 0, 0, dpr, 0, 0);
        };

        window.addEventListener('resize', resize);
        // Initial sizing attempt
        resize();

        // 3D Cyber Particles
        const particleCount = 35;
        const particles = [];
        for (let i = 0; i < particleCount; i++) {
            particles.push({
                x: (Math.random() - 0.5) * 2.2,
                y: Math.random() * 1.6 - 0.3,
                z: Math.random() * 1000 + 1,
                size: Math.random() * 2.5 + 1.2,
                color: Math.random() > 0.4 ? '#00f0ff' : (Math.random() > 0.5 ? '#bd00ff' : '#00ff88')
            });
        }

        let gridOffset = 0;
        const gridSpeed = 0.007; // Speed of motion forward
        const lineCount = 18;
        const numRadials = 16;

        let lastTime = performance.now();

        const render = (time) => {
            requestAnimationFrame(render);

            const lobbyView = document.getElementById('view-lobby');
            if (!lobbyView || !lobbyView.classList.contains('active')) {
                return; // Pause rendering when not on lobby screen to save power
            }

            const dt = Math.min((time - lastTime) / 1000, 0.1);
            lastTime = time;

            if (width === 0 || height === 0 || canvas.width === 0) {
                resize();
            }

            gridOffset = (gridOffset + gridSpeed * (dt * 60)) % 1;

            ctx.clearRect(0, 0, width, height);

            const horizonY = height * 0.42;
            const vanishingX = width * 0.5;

            // 1. Deep space background gradient
            const bgGrad = ctx.createLinearGradient(0, 0, 0, height);
            bgGrad.addColorStop(0, '#060914');
            bgGrad.addColorStop(0.42, '#0c1328');
            bgGrad.addColorStop(0.7, '#080d1e');
            bgGrad.addColorStop(1, '#040711');
            ctx.fillStyle = bgGrad;
            ctx.fillRect(0, 0, width, height);

            // 2. Horizon Glow Bloom
            const horizonGlow = ctx.createRadialGradient(vanishingX, horizonY, 5, vanishingX, horizonY, width * 0.75);
            horizonGlow.addColorStop(0, 'rgba(0, 240, 255, 0.45)');
            horizonGlow.addColorStop(0.25, 'rgba(168, 85, 247, 0.25)');
            horizonGlow.addColorStop(0.6, 'rgba(30, 58, 138, 0.1)');
            horizonGlow.addColorStop(1, 'rgba(0, 0, 0, 0)');
            ctx.fillStyle = horizonGlow;
            ctx.fillRect(0, horizonY - height * 0.35, width, height * 0.7);

            // 3. Ground Perspective Grid Lines (Radiating from Vanishing Point)
            ctx.lineWidth = 1;
            for (let i = -numRadials; i <= numRadials; i++) {
                const targetX = vanishingX + (i * (width / (numRadials * 0.45)));
                const grad = ctx.createLinearGradient(vanishingX, horizonY, targetX, height);
                grad.addColorStop(0, 'rgba(0, 240, 255, 0.05)');
                grad.addColorStop(0.3, 'rgba(0, 240, 255, 0.3)');
                grad.addColorStop(1, 'rgba(168, 85, 247, 0.65)');

                ctx.strokeStyle = grad;
                ctx.beginPath();
                ctx.moveTo(vanishingX, horizonY);
                ctx.lineTo(targetX, height);
                ctx.stroke();
            }

            // 4. Moving Horizontal Rungs (Ground)
            for (let i = 0; i < lineCount; i++) {
                const p = (i + gridOffset) / lineCount;
                // Non-linear power curve creates realistic 3D camera perspective
                const y = horizonY + Math.pow(p, 2.6) * (height - horizonY);
                const alpha = Math.min(1, Math.pow(p, 1.4) * 0.85);
                const lineWidth = 0.6 + p * 2.2;

                ctx.strokeStyle = `rgba(0, 240, 255, ${alpha})`;
                ctx.lineWidth = lineWidth;
                ctx.beginPath();
                ctx.moveTo(0, y);
                ctx.lineTo(width, y);
                ctx.stroke();

                // Subtle neon pulse along the closest lines
                if (p > 0.6) {
                    ctx.strokeStyle = `rgba(236, 72, 153, ${alpha * 0.4})`;
                    ctx.lineWidth = lineWidth * 1.5;
                    ctx.beginPath();
                    ctx.moveTo(0, y);
                    ctx.lineTo(width, y);
                    ctx.stroke();
                }
            }

            // 5. Ceiling / Upper Perspective (Subtle Cyber Grid)
            for (let i = -numRadials; i <= numRadials; i += 2) {
                const targetX = vanishingX + (i * (width / (numRadials * 0.5)));
                ctx.strokeStyle = 'rgba(139, 92, 246, 0.12)';
                ctx.lineWidth = 0.8;
                ctx.beginPath();
                ctx.moveTo(vanishingX, horizonY);
                ctx.lineTo(targetX, 0);
                ctx.stroke();
            }
            for (let i = 0; i < 7; i++) {
                const p = (i + gridOffset) / 7;
                const y = horizonY - Math.pow(p, 2.2) * horizonY;
                ctx.strokeStyle = `rgba(139, 92, 246, ${p * 0.25})`;
                ctx.lineWidth = 0.8;
                ctx.beginPath();
                ctx.moveTo(0, y);
                ctx.lineTo(width, y);
                ctx.stroke();
            }

            // 6. Horizon sharp neon laser line
            ctx.strokeStyle = 'rgba(0, 240, 255, 0.9)';
            ctx.lineWidth = 2;
            ctx.beginPath();
            ctx.moveTo(0, horizonY);
            ctx.lineTo(width, horizonY);
            ctx.stroke();

            // 7. 3D Flying Cyber Particles / Dust
            for (let i = 0; i < particles.length; i++) {
                const pt = particles[i];
                pt.z -= 450 * dt;
                if (pt.z <= 1) {
                    pt.z = 1000;
                    pt.x = (Math.random() - 0.5) * 2.2;
                    pt.y = Math.random() * 1.6 - 0.3;
                }

                // Project 3D -> 2D
                const k = 400 / pt.z;
                const px = vanishingX + pt.x * width * 0.8 * k;
                const py = horizonY + (pt.y - 0.4) * height * 0.9 * k;
                const pSize = Math.max(0.8, pt.size * k);
                const pAlpha = Math.min(1, (1000 - pt.z) / 400);

                if (px >= 0 && px <= width && py >= 0 && py <= height) {
                    ctx.fillStyle = pt.color;
                    ctx.globalAlpha = pAlpha;
                    ctx.beginPath();
                    ctx.arc(px, py, pSize, 0, Math.PI * 2);
                    ctx.fill();
                    ctx.globalAlpha = 1.0;
                }
            }
        };

        requestAnimationFrame(render);
    }

    bindClick(id, handler) {
        const el = document.getElementById(id);
        if (el) el.addEventListener('click', handler);
    }

    attachGlobalEvents() {
        document.querySelectorAll('.nav-tab').forEach(tab => {
            tab.addEventListener('click', () => {
                const tabTarget = tab.dataset.tab;
                this.switchScreen(tabTarget);
                document.querySelectorAll('.nav-tab').forEach(t => t.classList.remove('active'));
                tab.classList.add('active');
                window.soundManager.playClick();
            });
        });
        this.bindClick('btn-mode-classic', () => this.startMode('classic'));
        this.bindClick('btn-mode-adventure', () => this.startMode('adventure'));
        this.bindClick('btn-game-back', () => {
            window.soundManager.playClick();
            this.switchScreen('view-lobby');
            const lobbyTab = document.querySelector('.nav-tab[data-tab="view-lobby"]');
            if (lobbyTab) lobbyTab.click();
        });

        // Settings Modal Bindings
        this.bindClick('btn-settings', () => this.openSettings());
        this.bindClick('btn-lobby-settings', () => this.openSettings());
        this.bindClick('btn-close-settings', () => this.closeSettings());
        this.bindClick('btn-save-close-settings', () => this.closeSettings());
        this.bindClick('btn-toggle-sound', () => this.toggleSound());
        this.bindClick('btn-settings-exit-game', () => this.exitCurrentGame());

        const volumeSlider = document.getElementById('volume-slider');
        if (volumeSlider) {
            volumeSlider.addEventListener('input', (e) => this.onVolumeChange(e.target.value));
        }

        this.bindClick('btn-restart', () => { if (this.gameOverModal) this.gameOverModal.classList.remove('active'); this.startMode(this.gameMode); });
        this.bindClick('btn-go-lobby', () => { if (this.gameOverModal) this.gameOverModal.classList.remove('active'); this.switchScreen('view-lobby'); const lobbyTab = document.querySelector('.nav-tab[data-tab="view-lobby"]'); if (lobbyTab) lobbyTab.click(); });
        this.bindClick('tab-lb-classic', () => { this.lbCurrentTab = 'classic'; this.renderLeaderboard(); });
        this.bindClick('tab-lb-adventure', () => { this.lbCurrentTab = 'adventure'; this.renderLeaderboard(); });
        this.bindClick('btn-claim-daily', () => this.claimDailyReward());

        // Profile Modal Bindings
        this.bindClick('btn-top-profile', () => this.openProfileModal(null));
        this.bindClick('btn-close-profile', () => this.closeProfileModal());
        this.bindClick('btn-done-profile', () => this.closeProfileModal());

        const changeAvatarBtn = document.getElementById('btn-change-avatar');
        const fileInput = document.getElementById('avatar-file-input');
        if (changeAvatarBtn && fileInput) {
            changeAvatarBtn.addEventListener('click', () => fileInput.click());
            fileInput.addEventListener('change', (e) => {
                if (e.target.files && e.target.files[0]) {
                    this.handleAvatarUpload(e.target.files[0]);
                }
            });
        }

        const nameInput = document.getElementById('profile-player-name');
        const saveNameBtn = document.getElementById('btn-save-name');
        if (saveNameBtn) {
            saveNameBtn.addEventListener('click', () => this.savePlayerName());
        }
        if (nameInput) {
            nameInput.addEventListener('keydown', (e) => {
                if (e.key === 'Enter') this.savePlayerName();
            });
        }

        document.querySelectorAll('.preset-avatar-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const icon = btn.dataset.icon;
                if (icon) this.selectPresetAvatar(icon);
            });
        });

        window.addEventListener('pointermove', (e) => this.onPointerMove(e), { passive: false });
        window.addEventListener('pointerup', (e) => this.onPointerUp(e));
        window.addEventListener('pointercancel', (e) => this.onPointerUp(e));
        window.addEventListener('resize', () => this.updateGhostCellSize());
    }

    openProfileModal(targetPlayer = null) {
        const modal = document.getElementById('profile-modal');
        if (!modal) return;

        const titleEl = document.getElementById('profile-modal-title');
        const imgDisplay = document.getElementById('profile-avatar-display');
        const iconDisplay = document.getElementById('profile-avatar-icon-display');
        const changeAvatarBtn = document.getElementById('btn-change-avatar');
        const presetRow = document.getElementById('profile-preset-avatars-row');
        const nameInput = document.getElementById('profile-player-name');
        const saveNameBtn = document.getElementById('btn-save-name');

        const rankIconEl = document.getElementById('profile-rank-icon');
        const rankNameEl = document.getElementById('profile-rank-name');
        const rankLevelEl = document.getElementById('profile-rank-level');

        const classicRankEl = document.getElementById('profile-classic-rank');
        const classicBestEl = document.getElementById('profile-classic-best');
        const advRankEl = document.getElementById('profile-adv-rank');
        const advBestEl = document.getElementById('profile-adv-best');

        const achCountEl = document.getElementById('profile-ach-count');
        const achFillEl = document.getElementById('profile-ach-xp-fill');
        const achTextEl = document.getElementById('profile-ach-xp-text');

        const statBlocks = document.getElementById('pstat-blocks');
        const statLines = document.getElementById('pstat-lines');
        const statMaxCombo = document.getElementById('pstat-maxcombo');
        const statCoins = document.getElementById('pstat-coins');

        if (targetPlayer) {
            // View opponent / simulated player
            if (titleEl) titleEl.textContent = `👤 ${targetPlayer.name} Profilja`;
            if (changeAvatarBtn) changeAvatarBtn.style.display = 'none';
            if (presetRow) presetRow.style.display = 'none';
            if (saveNameBtn) saveNameBtn.style.display = 'none';
            if (nameInput) {
                nameInput.value = targetPlayer.name;
                nameInput.readOnly = true;
            }

            if (imgDisplay) imgDisplay.style.display = 'none';
            if (iconDisplay) {
                iconDisplay.textContent = targetPlayer.icon || '🤖';
                iconDisplay.style.display = 'block';
            }

            if (rankIconEl) rankIconEl.textContent = targetPlayer.rankIcon || '🏆';
            if (rankNameEl) rankNameEl.textContent = targetPlayer.rankTitle || 'Bajnok';
            if (rankLevelEl) rankLevelEl.textContent = `Mester Rang: ${targetPlayer.rankLevel || 1}. Szint`;

            const isClassic = this.lbCurrentTab === 'classic';
            if (classicRankEl) classicRankEl.textContent = isClassic ? `#${targetPlayer.rank}` : `#${Math.min(6, targetPlayer.rank + 1)}`;
            if (classicBestEl) classicBestEl.textContent = `${targetPlayer.score.toLocaleString()} pont`;
            if (advRankEl) advRankEl.textContent = !isClassic ? `#${targetPlayer.rank}` : `#${Math.max(1, targetPlayer.rank - 1)}`;
            if (advBestEl) advBestEl.textContent = `${Math.round(targetPlayer.score * 1.25).toLocaleString()} pont`;

            if (achCountEl) achCountEl.textContent = `${targetPlayer.achCount || 5} Teljesítve ✨`;
            if (achFillEl) achFillEl.style.width = `85%`;
            if (achTextEl) achTextEl.textContent = `Szint: ${targetPlayer.rankLevel || 1} • Rang: #${targetPlayer.rank}`;

            if (statBlocks) statBlocks.textContent = `${(targetPlayer.blocks || 2000).toLocaleString()} db`;
            if (statLines) statLines.textContent = `${(targetPlayer.lines || 400).toLocaleString()} sor`;
            if (statMaxCombo) statMaxCombo.textContent = `x${targetPlayer.maxCombo || 5}`;
            if (statCoins) statCoins.innerHTML = `${(targetPlayer.coins || 5000).toLocaleString()} <span class="gold-icon"></span>`;
        } else {
            // View own editable character profile
            if (titleEl) titleEl.textContent = '👤 Saját Karakter Profil';
            if (changeAvatarBtn) changeAvatarBtn.style.display = 'inline-block';
            if (presetRow) presetRow.style.display = 'flex';
            if (saveNameBtn) saveNameBtn.style.display = 'inline-block';
            if (nameInput) {
                nameInput.value = this.profile.playerName || 'Játékos';
                nameInput.readOnly = false;
            }

            if (this.profile.customAvatar) {
                if (imgDisplay) {
                    imgDisplay.src = this.profile.customAvatar;
                    imgDisplay.style.display = 'block';
                }
                if (iconDisplay) iconDisplay.style.display = 'none';
            } else {
                if (imgDisplay) imgDisplay.style.display = 'none';
                if (iconDisplay) {
                    iconDisplay.textContent = this.profile.avatarIcon || '🧑‍🚀';
                    iconDisplay.style.display = 'block';
                }
            }

            const mastery = this.getMasteryRankInfo();
            if (rankIconEl) rankIconEl.textContent = mastery.icon;
            if (rankNameEl) rankNameEl.textContent = mastery.name;
            if (rankLevelEl) rankLevelEl.textContent = `Mester Rang: ${mastery.rankIndex}. Szint`;

            const myClassicRank = this.getMyClassicRank();
            const myAdvRank = this.getMyAdventureRank();
            if (classicRankEl) classicRankEl.textContent = `#${myClassicRank}`;
            if (classicBestEl) classicBestEl.textContent = `${(this.profile.classicBest || 0).toLocaleString()} pont`;
            if (advRankEl) advRankEl.textContent = `#${myAdvRank}`;
            if (advBestEl) advBestEl.textContent = `${(this.profile.adventureBest || 0).toLocaleString()} pont`;

            const claimedCount = this.profile.claimedAchievementCount || 0;
            if (achCountEl) achCountEl.textContent = `${claimedCount} Teljesítve ✨`;
            if (achFillEl) achFillEl.style.width = `${mastery.pct}%`;
            if (achTextEl) achTextEl.textContent = mastery.xpText;

            const stats = this.profile.stats || {};
            const totalBlocks = (stats.blocksPlaced || 0) + (stats.advBlocksPlaced || 0);
            if (statBlocks) statBlocks.textContent = `${totalBlocks.toLocaleString()} db`;
            if (statLines) statLines.textContent = `${(stats.lines || 0).toLocaleString()} sor`;
            if (statMaxCombo) statMaxCombo.textContent = `x${stats.combos || stats.maxCombo || 1}`;
            if (statCoins) statCoins.innerHTML = `${(this.profile.totalCoinsEarned || this.profile.coins || 0).toLocaleString()} <span class="gold-icon"></span>`;
        }

        modal.classList.add('active');
        window.soundManager.playClick();
    }

    closeProfileModal() {
        const modal = document.getElementById('profile-modal');
        if (modal) modal.classList.remove('active');
        window.soundManager.playClick();
    }

    handleAvatarUpload(file) {
        if (!file || !file.type.startsWith('image/')) return;
        const reader = new FileReader();
        reader.onload = (e) => {
            const img = new Image();
            img.onload = () => {
                const canvas = document.createElement('canvas');
                const maxDim = 256;
                let w = img.width;
                let h = img.height;
                if (w > h) {
                    if (w > maxDim) {
                        h = Math.round((h * maxDim) / w);
                        w = maxDim;
                    }
                } else {
                    if (h > maxDim) {
                        w = Math.round((w * maxDim) / h);
                        h = maxDim;
                    }
                }
                canvas.width = w;
                canvas.height = h;
                const ctx = canvas.getContext('2d');
                ctx.drawImage(img, 0, 0, w, h);
                const dataUrl = canvas.toDataURL('image/jpeg', 0.85);

                this.profile.customAvatar = dataUrl;
                this.saveProfile();
                this.openProfileModal(null);
                window.soundManager.playLevelUp();
            };
            img.src = e.target.result;
        };
        reader.readAsDataURL(file);
    }

    selectPresetAvatar(icon) {
        this.profile.customAvatar = null;
        this.profile.avatarIcon = icon;
        this.saveProfile();
        this.openProfileModal(null);
        window.soundManager.playClick();
    }

    savePlayerName() {
        const input = document.getElementById('profile-player-name');
        if (input) {
            const name = input.value.trim();
            if (name) {
                this.profile.playerName = name;
                this.saveProfile();
                this.updateProfileUI();
                window.soundManager.playClick();
            }
        }
    }

    openSettings() {
        const isIngame = document.body.classList.contains('in-game') || 
                         (document.getElementById('view-game') && document.getElementById('view-game').classList.contains('active'));
        this.isSettingsIngame = isIngame;
        const ingameSection = document.getElementById('settings-ingame-section');
        if (ingameSection) {
            ingameSection.style.display = isIngame ? 'block' : 'none';
        }
        this.updateSettingsUI();
        if (this.settingsModal) this.settingsModal.classList.add('active');
        window.soundManager.playClick();
    }

    closeSettings() {
        if (this.settingsModal) this.settingsModal.classList.remove('active');
        window.soundManager.playClick();
    }

    switchScreen(screenId) {
        const bottomNav = document.getElementById('bottom-nav');
        if (screenId === 'view-game') { 
            document.body.classList.add('in-game'); 
            if (bottomNav) bottomNav.classList.add('nav-hidden'); 
        } else { 
            document.body.classList.remove('in-game'); 
            if (bottomNav) bottomNav.classList.remove('nav-hidden'); 
        }
        document.querySelectorAll('.screen-view').forEach(v => v.classList.remove('active'));
        const targetView = document.getElementById(screenId);
        if (targetView) targetView.classList.add('active');
        if (screenId === 'view-shop') this.renderShop();
        if (screenId === 'view-upgrades') this.renderUpgrades();
        if (screenId === 'view-achievements') this.renderAchievements();
        if (screenId === 'view-leaderboard') this.renderLeaderboard();
        if (screenId === 'view-lobby') this.updateLobbyMeta();
    }

    updateSettingsUI() {
        const slider = document.getElementById('volume-slider');
        const valText = document.getElementById('volume-val-display');
        const soundBtn = document.getElementById('btn-toggle-sound');
        const iconEl = document.getElementById('sound-status-icon');
        const textEl = document.getElementById('sound-status-text');

        const volPercent = Math.round((window.soundManager.volume ?? 0.8) * 100);
        if (slider) slider.value = volPercent;
        if (valText) valText.textContent = `${volPercent}%`;

        const isMuted = window.soundManager.muted;
        if (soundBtn) soundBtn.classList.toggle('muted', isMuted);
        if (iconEl) iconEl.textContent = isMuted ? '🔇' : '🔊';
        if (textEl) textEl.textContent = isMuted ? 'Hangok Némítva' : 'Hangok Bekapcsolva';
    }

    toggleSound() {
        window.soundManager.toggleMute();
        this.updateSettingsUI();
        if (!window.soundManager.muted) window.soundManager.playClick();
    }

    onVolumeChange(value) {
        const vol = Math.max(0, Math.min(100, parseInt(value, 10))) / 100;
        window.soundManager.setVolume(vol);
        const valText = document.getElementById('volume-val-display');
        if (valText) valText.textContent = `${Math.round(vol * 100)}%`;
    }

    exitCurrentGame() {
        this.closeSettings();
        this.triggerGameOver('Játék befejezve (Kilépés)');
    }

    startMode(mode) {
        this.gameMode = mode;
        this.switchScreen('view-game');
        window.soundManager.playClick();
        this.grid = Array(8).fill(null).map(() => Array(8).fill(null));
        this.score = 0;
        this.comboStreak = 0;
        this.sessionCoins = 0;
        const modeBadge = document.getElementById('ingame-mode-title');
        const scoreTitle = document.getElementById('score-card-title');
        const targetTitle = document.getElementById('target-card-title');
        if (mode === 'classic') {
            if (modeBadge) modeBadge.textContent = '🕹️ Klasszikus Mód';
            if (scoreTitle) scoreTitle.textContent = 'Pontszám';
            if (targetTitle) targetTitle.textContent = 'Rekord 🏆';
            if (this.highScoreEl) this.highScoreEl.textContent = (this.profile.classicBest || 0).toLocaleString();
            if (this.adventureObjBar) this.adventureObjBar.style.display = 'none';
        } else {
            if (modeBadge) modeBadge.textContent = '🚀 Kaland Mód';
            if (scoreTitle) scoreTitle.textContent = 'Pontszám';
            if (targetTitle) targetTitle.textContent = 'Rekord 🏆';
            if (this.highScoreEl) this.highScoreEl.textContent = (this.profile.adventureBest || 0).toLocaleString();
            this.movesLeft = 10 + (this.profile.upgrades.extraMoves || 0);
            if (this.adventureObjBar) this.adventureObjBar.style.display = 'flex';
            this.updateAdventureObjUI();
        }
        this.renderBoard();
        this.updateScoreDisplay();
        this.updateComboBanner();
        for (let i = 0; i < 3; i++) this.spawnPieceInSlot(i);
        this.updateDockAvailability();
    }

    updateAdventureObjUI() {
        if (this.movesLeftDisplay) this.movesLeftDisplay.textContent = `⏳ Hátralévő lépések: ${this.movesLeft}`;
        if (this.movesUpgradeInfo) {
            const extraMoves = this.profile.upgrades.extraMoves || 0;
            const skipChance = (this.profile.upgrades.skipChance || 0) * 0.2;
            this.movesUpgradeInfo.textContent = `✨ +${extraMoves} Lépés | ${skipChance.toFixed(1)}% Ingyen`;
        }
    }

    getRandomShape() {
        const randIndex = Math.floor(Math.random() * SHAPES.length);
        const template = SHAPES[randIndex];
        const matrix = template.matrix.map(row => [...row]);
        if (this.gameMode === 'adventure') {
            for (let r = 0; r < matrix.length; r++) {
                for (let c = 0; c < matrix[r].length; c++) {
                    if (matrix[r][c] === 1 && Math.random() < 0.22) matrix[r][c] = 2;
                }
            }
        }
        return { matrix, color: template.color, name: template.name };
    }

    spawnPieceInSlot(slotIndex) {
        this.dockPieces[slotIndex] = this.getRandomShape();
        this.renderDockSlot(slotIndex);
    }

    renderDockSlot(slotIndex) {
        const slotEl = this.dockSlots[slotIndex];
        if (!slotEl) return;
        slotEl.innerHTML = '';
        const piece = this.dockPieces[slotIndex];
        if (!piece) return;
        const pieceEl = document.createElement('div');
        pieceEl.className = 'piece';
        pieceEl.style.gridTemplateRows = `repeat(${piece.matrix.length}, 1fr)`;
        pieceEl.style.gridTemplateColumns = `repeat(${piece.matrix[0].length}, 1fr)`;
        piece.matrix.forEach(r => r.forEach(v => {
            const block = document.createElement('div');
            block.className = v > 0 ? `piece-block ${piece.color} ${v === 2 ? 'has-coin' : ''}` : 'piece-block empty';
            pieceEl.appendChild(block);
        }));
        pieceEl.addEventListener('pointerdown', (e) => this.onPointerDown(e, slotIndex));
        slotEl.appendChild(pieceEl);
    }

    onPointerDown(e, slotIndex) {
        const piece = this.dockPieces[slotIndex];
        if (!piece) return;
        this.clearBoardPreview();
        this.isDragging = false;
        if (!this.canPieceFitAnywhere(piece)) return;
        e.preventDefault();
        window.soundManager.playPickup();
        this.isDragging = true;
        this.draggedSlotIndex = slotIndex;
        this.draggedPiece = piece;
        const slotEl = this.dockSlots[slotIndex];
        if (slotEl) slotEl.querySelector('.piece').classList.add('dragging');
        this.createDragGhost(piece);
        this.updateGhostCellSize();
        this.updateGhostPosition(e);
        this.updateBoardPreview(e);
    }

    createDragGhost(piece) {
        if (!this.dragGhost) return;
        this.dragGhost.innerHTML = '';
        this.dragGhost.style.gridTemplateRows = `repeat(${piece.matrix.length}, 1fr)`;
        this.dragGhost.style.gridTemplateColumns = `repeat(${piece.matrix[0].length}, 1fr)`;
        piece.matrix.forEach(r => r.forEach(v => {
            const b = document.createElement('div');
            b.className = v > 0 ? `piece-block ${piece.color} ${v === 2 ? 'has-coin' : ''}` : 'piece-block empty';
            this.dragGhost.appendChild(b);
        }));
        this.dragGhost.style.display = 'grid';
    }

    updateGhostCellSize() {
        const firstCell = this.boardEl?.querySelector('.cell');
        if (firstCell) document.documentElement.style.setProperty('--ghost-block-size', `${firstCell.getBoundingClientRect().width}px`);
    }

    onPointerMove(e) {
        if (!this.isDragging || !this.draggedPiece) return;
        e.preventDefault();
        this.updateGhostPosition(e);
        this.updateBoardPreview(e);
    }

    updateGhostPosition(e) {
        if (!this.dragGhost) return;
        const isTouch = e.pointerType === 'touch' || (e.touches?.length > 0);
        const x = e.clientX ?? (e.touches?.[0].clientX ?? 0);
        const y = e.clientY ?? (e.touches?.[0].clientY ?? 0);
        this.dragGhost.style.left = `${x}px`;
        this.dragGhost.style.top = `${y - (isTouch ? this.touchOffsetY : 0)}px`;
    }

    getPlacementTarget(e) {
        if (!this.draggedPiece || !this.boardEl) return null;
        const isTouch = e.pointerType === 'touch' || (e.touches?.length > 0);
        const x = e.clientX ?? (e.touches?.[0].clientX ?? 0);
        const y = (e.clientY ?? (e.touches?.[0].clientY ?? 0)) - (isTouch ? this.touchOffsetY : 0);
        const br = this.boardEl.getBoundingClientRect();
        const cw = br.width / this.boardSize;
        return { 
            startRow: Math.round(((y - (this.draggedPiece.matrix.length * cw) / 2) - br.top) / cw), 
            startCol: Math.round(((x - (this.draggedPiece.matrix[0].length * cw) / 2) - br.left) / cw) 
        };
    }

    updateBoardPreview(e) {
        this.clearBoardPreview();
        const target = this.getPlacementTarget(e);
        if (!target) return;
        const { startRow, startCol } = target;
        if (this.canPlacePiece(this.draggedPiece, startRow, startCol)) {
            const rows = this.draggedPiece.matrix.length;
            const cols = this.draggedPiece.matrix[0].length;

            // Highlight placement preview blocks
            this.draggedPiece.matrix.forEach((r, ri) => r.forEach((v, ci) => {
                if (v > 0) this.getCellElement(startRow + ri, startCol + ci)?.classList.add('preview');
            }));

            // Check which rows and columns would be completely cleared and light them up!
            const willClearRows = [];
            const willClearCols = [];

            for (let r = 0; r < this.boardSize; r++) {
                let rowFull = true;
                for (let c = 0; c < this.boardSize; c++) {
                    const hasGrid = this.grid[r][c] !== null;
                    const isPiece = (
                        r >= startRow && r < startRow + rows &&
                        c >= startCol && c < startCol + cols &&
                        this.draggedPiece.matrix[r - startRow][c - startCol] > 0
                    );
                    if (!hasGrid && !isPiece) {
                        rowFull = false;
                        break;
                    }
                }
                if (rowFull) willClearRows.push(r);
            }

            for (let c = 0; c < this.boardSize; c++) {
                let colFull = true;
                for (let r = 0; r < this.boardSize; r++) {
                    const hasGrid = this.grid[r][c] !== null;
                    const isPiece = (
                        r >= startRow && r < startRow + rows &&
                        c >= startCol && c < startCol + cols &&
                        this.draggedPiece.matrix[r - startRow][c - startCol] > 0
                    );
                    if (!hasGrid && !isPiece) {
                        colFull = false;
                        break;
                    }
                }
                if (colFull) willClearCols.push(c);
            }

            willClearRows.forEach(r => {
                for (let c = 0; c < this.boardSize; c++) {
                    this.getCellElement(r, c)?.classList.add('will-clear');
                }
            });
            willClearCols.forEach(c => {
                for (let r = 0; r < this.boardSize; r++) {
                    this.getCellElement(r, c)?.classList.add('will-clear');
                }
            });
        }
    }

    clearBoardPreview() {
        if (!this.boardEl) return;
        this.boardEl.querySelectorAll('.cell.preview, .cell.will-clear').forEach(c => {
            c.classList.remove('preview', 'will-clear');
        });
    }

    onPointerUp(e) {
        if (!this.isDragging) return;
        this.clearBoardPreview();
        if (this.dragGhost) this.dragGhost.style.display = 'none';
        const target = this.getPlacementTarget(e);
        if (target && this.canPlacePiece(this.draggedPiece, target.startRow, target.startCol)) {
            this.placePiece(this.draggedPiece, target.startRow, target.startCol, this.draggedSlotIndex);
        } else if (this.draggedSlotIndex !== null) {
            this.dockSlots[this.draggedSlotIndex]?.querySelector('.piece')?.classList.remove('dragging');
        }
        this.isDragging = false;
        this.draggedSlotIndex = null;
        this.draggedPiece = null;
    }

    canPlacePiece(piece, startRow, startCol) {
        return piece.matrix.every((r, ri) => r.every((v, ci) => v === 0 || 
            (startRow + ri >= 0 && startRow + ri < 8 && startCol + ci >= 0 && startCol + ci < 8 && !this.grid[startRow + ri][startCol + ci])));
    }

    canPieceFitAnywhere(piece) {
        for (let r = 0; r <= 8 - piece.matrix.length; r++) {
            for (let c = 0; c <= 8 - piece.matrix[0].length; c++) {
                if (this.canPlacePiece(piece, r, c)) return true;
            }
        }
        return false;
    }

    placePiece(piece, startRow, startCol, slotIndex) {
        let blockCount = 0;
        piece.matrix.forEach((r, ri) => r.forEach((v, ci) => {
            if (v > 0) {
                this.grid[startRow + ri][startCol + ci] = { color: piece.color, hasCoin: v === 2 };
                blockCount++;
            }
        }));
        window.soundManager.playPlace();
        this.profile.stats.blocksPlaced = (this.profile.stats.blocksPlaced || 0) + blockCount;
        if (this.gameMode === 'adventure') {
            this.profile.stats.advBlocksPlaced = (this.profile.stats.advBlocksPlaced || 0) + blockCount;
            if (Math.random() * 100 >= (this.profile.upgrades.skipChance || 0) * 0.2) {
                this.movesLeft--;
            } else {
                this.showFloatingScore('✨ INGYEN LÉPÉS! ✨');
                window.soundManager.playLevelUp();
            }
            this.updateAdventureObjUI();
        }

        // Pontozás: minden lerakott kocka 1 pont
        const placedPoints = blockCount * 1;
        this.addScore(placedPoints);

        this.spawnPieceInSlot(slotIndex);
        this.renderBoard();
        this.checkAndClearLines();
    }

    checkAndClearLines() {
        const fullRows = [];
        const fullCols = [];

        // Teljes sorok keresése
        for (let r = 0; r < this.boardSize; r++) {
            let rowFull = true;
            for (let c = 0; c < this.boardSize; c++) {
                if (!this.grid[r][c]) {
                    rowFull = false;
                    break;
                }
            }
            if (rowFull) fullRows.push(r);
        }

        // Teljes oszlopok keresése
        for (let c = 0; c < this.boardSize; c++) {
            let colFull = true;
            for (let r = 0; r < this.boardSize; r++) {
                if (!this.grid[r][c]) {
                    colFull = false;
                    break;
                }
            }
            if (colFull) fullCols.push(c);
        }

        const totalLines = fullRows.length + fullCols.length;
        if (totalLines > 0) {
            this.comboStreak++;

            const clearedCoords = new Set();
            fullRows.forEach(r => {
                for (let c = 0; c < this.boardSize; c++) clearedCoords.add(`${r},${c}`);
            });
            fullCols.forEach(c => {
                for (let r = 0; r < this.boardSize; r++) clearedCoords.add(`${r},${c}`);
            });

            // Pontozás: minden eltüntetett kocka 10 pont, egymás utáni törléseknél 1.5-ös szorzóval
            const clearedCount = clearedCoords.size;
            const baseClearScore = clearedCount * 10;
            const multiplier = Math.pow(1.5, this.comboStreak - 1);
            const clearPoints = Math.round(baseClearScore * multiplier);
            this.addScore(clearPoints);

            window.soundManager.playClear(totalLines, this.comboStreak);

            let coinsCollected = 0;
            clearedCoords.forEach(coord => {
                const [r, c] = coord.split(',').map(Number);
                const cellData = this.grid[r][c];
                if (cellData) {
                    if (cellData.hasCoin) coinsCollected++;
                    if (cellData.color) {
                        if (!this.profile.stats.destroyedColors) this.profile.stats.destroyedColors = {};
                        this.profile.stats.destroyedColors[cellData.color] = (this.profile.stats.destroyedColors[cellData.color] || 0) + 1;
                    }
                }
                // Animáció indítása a törölt mezőkön
                const cellEl = this.getCellElement(r, c);
                if (cellEl) cellEl.classList.add('clearing');

                // Azonnal töröljük az adatstruktúrából
                this.grid[r][c] = null;
            });

            if (coinsCollected > 0) {
                this.addCoins(coinsCollected);
                window.soundManager.playCoin();
                this.showFloatingScore(`+${coinsCollected} 🪙 Arany!`);
            }

            this.profile.stats.lines = (this.profile.stats.lines || 0) + totalLines;
            this.profile.stats.combos = Math.max(this.profile.stats.combos || 0, this.comboStreak);
            this.saveProfile();
            this.checkAchievements();

            if (totalLines >= 2 || this.comboStreak >= 2) {
                if (this.boardEl) {
                    this.boardEl.classList.remove('shake');
                    void this.boardEl.offsetWidth;
                    this.boardEl.classList.add('shake');
                }
            }

            if (this.comboStreak > 1) {
                this.showFloatingScore(`+${clearPoints} (${clearedCount} Kocka x${multiplier.toFixed(1)})`);
            } else {
                this.showFloatingScore(`+${clearPoints} (${clearedCount} Kocka!)`);
            }

            // Animáció lefutása után újrarendereljük a táblát
            setTimeout(() => {
                this.renderBoard();
                this.afterTurnValidation();
            }, 260);
        } else {
            this.comboStreak = 0;
            this.afterTurnValidation();
        }
        this.updateComboBanner();
    }

    afterTurnValidation() {
        if (this.gameMode === 'adventure') {
            this.updateAdventureObjUI();
            if (this.movesLeft <= 0) {
                this.triggerGameOver('Elfogyott az összes lépésed!');
                return;
            }
        }
        this.updateDockAvailability();
        if (![0,1,2].some(i => this.canPieceFitAnywhere(this.dockPieces[i]))) {
            this.triggerGameOver('Nincs több érvényes lépés!');
        }
    }

    updateDockAvailability() {
        [0,1,2].forEach(i => {
            const slot = this.dockSlots[i];
            const piece = this.dockPieces[i];
            if (slot) {
                const pieceEl = slot.querySelector('.piece');
                if (pieceEl && piece) {
                    pieceEl.classList.toggle('disabled', !this.canPieceFitAnywhere(piece));
                }
            }
        });
    }

    triggerGameOver(reason) {
        setTimeout(() => {
            window.soundManager.playGameOver();
            const descEl = document.getElementById('go-desc');
            const finalScoreEl = document.getElementById('final-score');
            const finalCoinsEl = document.getElementById('final-coins');

            if (descEl) descEl.textContent = reason;
            if (finalScoreEl) finalScoreEl.textContent = this.score.toLocaleString();
            if (finalCoinsEl) finalCoinsEl.innerHTML = `+${this.sessionCoins} <span class="gold-icon"></span>`;

            if (this.score > (this.profile[this.gameMode + 'Best'] || 0)) {
                this.profile[this.gameMode + 'Best'] = this.score;
                this.saveProfile();
            }
            this.gameOverModal?.classList.add('active');
        }, 400);
    }

    addScore(points) {
        this.score += points;
        if (this.score > (this.profile[this.gameMode + 'Best'] || 0)) {
            this.profile[this.gameMode + 'Best'] = this.score;
            this.saveProfile();
            if (this.highScoreEl) this.highScoreEl.textContent = this.profile[this.gameMode + 'Best'].toLocaleString();
        }
        this.updateScoreDisplay();
        if (this.scoreEl) {
            this.scoreEl.classList.remove('score-pop');
            void this.scoreEl.offsetWidth;
            this.scoreEl.classList.add('score-pop');
        }
    }

    updateScoreDisplay() {
        if (this.scoreEl) this.scoreEl.textContent = this.score.toLocaleString();
    }

    updateComboBanner() {
        if (this.comboBannerEl) {
            this.comboBannerEl.textContent = `🔥 COMBO x${this.comboStreak}!`;
            this.comboBannerEl.classList.toggle('visible', this.comboStreak > 1);
        }
    }

    showFloatingScore(text) {
        if (!this.boardEl || !this.boardEl.parentElement) return;
        const floatEl = document.createElement('div');
        floatEl.className = 'floating-text';
        floatEl.textContent = text;
        floatEl.style.left = '50%'; floatEl.style.top = '45%';
        this.boardEl.parentElement.appendChild(floatEl);
        setTimeout(() => floatEl.remove(), 850);
    }

    renderBoard() {
        for (let r = 0; r < 8; r++) {
            for (let c = 0; c < 8; c++) {
                const cell = this.getCellElement(r, c);
                if (!cell) continue;
                cell.className = 'cell';
                const cellData = this.grid[r][c];
                if (cellData) {
                    cell.classList.add('filled', cellData.color);
                    if (cellData.hasCoin) cell.classList.add('has-coin');
                }
            }
        }
    }

    /* -------------------------------------------------------------
       BOLT (SHOP)
       ------------------------------------------------------------- */
    renderShop() {
        const container = document.getElementById('shop-themes-list');
        if (!container) return;
        container.innerHTML = '';

        THEMES.forEach(theme => {
            const isOwned = this.profile.ownedThemes.includes(theme.id);
            const isEquipped = this.profile.equippedTheme === theme.id;

            const card = document.createElement('div');
            card.className = `theme-card ${isEquipped ? 'active' : ''}`;

            let buttonHtml = '';
            if (isEquipped) {
                buttonHtml = `<button class="btn-theme-action btn-equipped">Felszerelve ✓</button>`;
            } else if (isOwned) {
                buttonHtml = `<button class="btn-theme-action btn-equip" data-theme="${theme.id}">Felszerelés</button>`;
            } else {
                buttonHtml = `<button class="btn-theme-action btn-buy" data-theme="${theme.id}" data-price="${theme.price}">Megvétel (${theme.price} <span class="gold-icon"></span>)</button>`;
            }

            const swatchesHtml = theme.swatches.map(color => `<div class="theme-swatch" style="background: ${color};"></div>`).join('');

            card.innerHTML = `
                <div class="theme-name">${theme.name}</div>
                <div class="theme-swatches">${swatchesHtml}</div>
                ${buttonHtml}
            `;

            container.appendChild(card);
        });

        container.querySelectorAll('.btn-buy').forEach(btn => {
            btn.addEventListener('click', () => {
                this.buyTheme(btn.dataset.theme, parseInt(btn.dataset.price, 10));
            });
        });

        container.querySelectorAll('.btn-equip').forEach(btn => {
            btn.addEventListener('click', () => {
                this.equipTheme(btn.dataset.theme);
            });
        });

        const dailyBtn = document.getElementById('btn-claim-daily');
        if (dailyBtn) {
            const today = new Date().toDateString();
            if (this.profile.lastDailyClaim === today) {
                dailyBtn.classList.add('disabled');
                dailyBtn.textContent = 'Már átvéve ✓';
            } else {
                dailyBtn.classList.remove('disabled');
                dailyBtn.textContent = 'Átvétel 🎁';
            }
        }
    }

    buyTheme(themeId, price) {
        if (this.profile.coins < price) {
            alert('Nincs elég érméd a téma megvásárlásához!');
            return;
        }
        this.profile.coins -= price;
        this.profile.ownedThemes.push(themeId);
        this.profile.equippedTheme = themeId;
        this.saveProfile();
        this.applyTheme(themeId);
        this.renderShop();
        window.soundManager.playCoin();
    }

    equipTheme(themeId) {
        this.profile.equippedTheme = themeId;
        this.saveProfile();
        this.applyTheme(themeId);
        this.renderShop();
        window.soundManager.playClick();
    }

    applyTheme(themeId) {
        document.body.className = `theme-${themeId}`;
    }

    claimDailyReward() {
        const today = new Date().toDateString();
        if (this.profile.lastDailyClaim === today) return;

        this.profile.coins += 100;
        this.profile.lastDailyClaim = today;
        this.saveProfile();
        this.renderShop();
        window.soundManager.playCoin();
        alert('🎉 Sikeresen átvetted a napi bónuszt: +100 Arany 🪙!');
    }

    /* -------------------------------------------------------------
       FEJLESZTÉSEK (UPGRADES)
       ------------------------------------------------------------- */
    renderUpgrades() {
        const container = document.getElementById('upgrades-list');
        if (!container) return;
        container.innerHTML = '';

        UPGRADES_DEF.forEach(upg => {
            const currentLvl = this.profile.upgrades[upg.id] || 0;
            const isMax = currentLvl >= upg.maxLvl;
            const nextCost = upg.baseCost * (currentLvl + 1);

            let statText = '';
            if (upg.id === 'extraMoves') {
                statText = `+${currentLvl} Lépés (Kezdés: ${10 + currentLvl} lépés)`;
            } else if (upg.id === 'skipChance') {
                statText = `+${(currentLvl * 0.2).toFixed(1)}% Esély`;
            }

            const card = document.createElement('div');
            card.className = 'upgrade-card';

            card.innerHTML = `
                <div class="upgrade-icon-wrap">${upg.icon}</div>
                <div class="upgrade-info">
                    <div class="upgrade-title-row">
                        <h3>${upg.name}</h3>
                        <span class="upgrade-lvl">${isMax ? 'MAX' : `LV ${currentLvl}/${upg.maxLvl}`}</span>
                    </div>
                    <p class="upgrade-desc">${upg.desc}</p>
                    <div style="font-size: 0.78rem; color: #60a5fa; font-weight: 700; margin-top: 4px;">Aktuális bónusz: ${statText}</div>
                </div>
                ${isMax ? 
                    `<button class="btn-upgrade maxed">MAX</button>` :
                    `<button class="btn-upgrade" data-upg="${upg.id}" data-cost="${nextCost}">
                        <span>Fejlesztés</span>
                        <span>${nextCost} <span class="gold-icon"></span></span>
                    </button>`
                }
            `;

            container.appendChild(card);
        });

        container.querySelectorAll('.btn-upgrade:not(.maxed)').forEach(btn => {
            btn.addEventListener('click', () => {
                this.buyUpgrade(btn.dataset.upg, parseInt(btn.dataset.cost, 10));
            });
        });
    }

    buyUpgrade(upgId, cost) {
        if (this.profile.coins < cost) {
            alert('Nincs elég érméd ehhez a fejlesztéshez!');
            return;
        }

        this.profile.coins -= cost;
        this.profile.upgrades[upgId] = (this.profile.upgrades[upgId] || 0) + 1;
        this.addXp(40);
        this.saveProfile();
        this.renderUpgrades();
        window.soundManager.playLevelUp();
    }

    /* -------------------------------------------------------------
       ACHIEVEMENTS VIEW (UNIFIED)
       ------------------------------------------------------------- */
    renderAchievements() {
        this.renderAchievementXpHero();
        this.renderAchievementsList();
    }

    renderAchievementXpHero() {
        const achXp = this.profile.achievementXp || 0;
        const claimedCount = this.profile.claimedAchievementCount || 0;

        let currentRank = MASTERY_RANKS[0];
        let nextRank = MASTERY_RANKS[1];
        for (let i = 0; i < MASTERY_RANKS.length; i++) {
            if (achXp >= MASTERY_RANKS[i].minXp) {
                currentRank = MASTERY_RANKS[i];
                nextRank = MASTERY_RANKS[i + 1] || null;
            }
        }

        const iconEl = document.getElementById('ach-hero-rank-icon');
        const titleEl = document.getElementById('ach-hero-rank-title');
        const levelEl = document.getElementById('ach-hero-rank-level');
        const countEl = document.getElementById('ach-hero-count');
        const xpTextEl = document.getElementById('ach-hero-xp-text');
        const xpFillEl = document.getElementById('ach-hero-xp-fill');

        if (iconEl) iconEl.textContent = currentRank.icon;
        if (titleEl) titleEl.textContent = currentRank.name;
        if (levelEl) {
            const rankIndex = MASTERY_RANKS.indexOf(currentRank) + 1;
            levelEl.textContent = `Mester Rang: ${rankIndex}. Szint`;
        }
        if (countEl) countEl.textContent = `${claimedCount} Teljesítve ✨`;

        if (nextRank) {
            const xpInLevel = achXp - currentRank.minXp;
            const xpNeeded = currentRank.maxXp - currentRank.minXp;
            const pct = Math.min(100, Math.max(0, Math.round((xpInLevel / xpNeeded) * 100)));
            if (xpTextEl) xpTextEl.textContent = `${achXp} / ${currentRank.maxXp} XP`;
            if (xpFillEl) xpFillEl.style.width = `${pct}%`;
        } else {
            if (xpTextEl) xpTextEl.textContent = `${achXp} XP (MAX)`;
            if (xpFillEl) xpFillEl.style.width = `100%`;
        }
    }

    renderAchievementsList() {
        const container = document.getElementById('achievements-list');
        if (!container) return;
        container.innerHTML = '';

        const items = ACHIEVEMENTS_DEF.map(ach => {
            const tier = (this.profile.achievementTiers && this.profile.achievementTiers[ach.id]) || 1;
            const currentVal = ach.getStat(this.profile);
            const goal = ach.getGoal(tier);
            const isReady = currentVal >= goal;
            const progressPct = Math.min(100, Math.round((currentVal / goal) * 100));
            const rewardCoins = ach.getRewardCoins(tier);
            const rewardXp = ach.getRewardXp(tier);

            return {
                ach,
                tier,
                currentVal,
                goal,
                isReady,
                progressPct,
                rewardCoins,
                rewardXp
            };
        });

        items.sort((a, b) => {
            if (a.isReady && !b.isReady) return -1;
            if (!a.isReady && b.isReady) return 1;
            return b.progressPct - a.progressPct;
        });

        items.forEach(item => {
            const { ach, tier, currentVal, goal, isReady, progressPct, rewardCoins, rewardXp } = item;
            const romanTier = getRomanNumeral(tier);

            const card = document.createElement('div');
            card.className = `achievement-card ${isReady ? 'ready-claim' : ''}`;

            let claimButtonHtml = '';
            if (isReady) {
                claimButtonHtml = `<button class="btn-claim-ach" data-ach="${ach.id}">Átvétel (+${rewardCoins} <span class="gold-icon"></span>, +${rewardXp} XP)</button>`;
            } else {
                claimButtonHtml = `<span style="font-size: 0.78rem; color: #8e9bb0; font-weight:700; white-space:nowrap;">${currentVal.toLocaleString()}/${goal.toLocaleString()}</span>`;
            }

            card.innerHTML = `
                <div class="ach-icon">${ach.icon}</div>
                <div class="ach-info">
                    <div class="ach-title-row">
                        <h4>${ach.title}</h4>
                        <span class="ach-tier-badge">Tier ${romanTier}</span>
                    </div>
                    <p>${ach.desc(goal)}</p>
                    <div class="ach-progress-bar">
                        <div class="ach-progress-fill" style="width: ${progressPct}%;"></div>
                    </div>
                </div>
                ${claimButtonHtml}
            `;

            container.appendChild(card);
        });

        container.querySelectorAll('.btn-claim-ach').forEach(btn => {
            btn.addEventListener('click', () => {
                this.claimAchievement(btn.dataset.ach);
            });
        });
    }

    claimAchievement(achId) {
        const def = ACHIEVEMENTS_DEF.find(a => a.id === achId);
        if (!def) return;

        if (!this.profile.achievementTiers) this.profile.achievementTiers = {};
        const currentTier = this.profile.achievementTiers[achId] || 1;
        const currentVal = def.getStat(this.profile);
        const goal = def.getGoal(currentTier);

        if (currentVal < goal) return;

        const rewardCoins = def.getRewardCoins(currentTier);
        const rewardXp = def.getRewardXp(currentTier);

        this.profile.achievementTiers[achId] = currentTier + 1;
        this.profile.achievementXp = (this.profile.achievementXp || 0) + rewardXp;
        this.profile.claimedAchievementCount = (this.profile.claimedAchievementCount || 0) + 1;

        this.addCoins(rewardCoins);
        this.addXp(rewardXp);
        this.saveProfile();
        this.renderAchievements();
        window.soundManager.playLevelUp();
        this.showFloatingScore(`+${rewardCoins} 🪙 & +${rewardXp} XP!`);
    }

    checkAchievements() {
        this.renderAchievements();
    }

    /* -------------------------------------------------------------
       LEADERBOARD VIEW
       ------------------------------------------------------------- */
    renderLeaderboard() {
        const isClassic = this.lbCurrentTab === 'classic';
        const dataset = isClassic ? SIMULATED_CLASSIC_LEADERBOARD : SIMULATED_ADVENTURE_LEADERBOARD;

        const p1n = document.getElementById('podium-1-name');
        const p1s = document.getElementById('podium-1-score');
        const p2n = document.getElementById('podium-2-name');
        const p2s = document.getElementById('podium-2-score');
        const p3n = document.getElementById('podium-3-name');
        const p3s = document.getElementById('podium-3-score');

        if (dataset[0]) {
            if (p1n) p1n.textContent = dataset[0].name;
            if (p1s) p1s.textContent = `${dataset[0].score.toLocaleString()} pont`;
        }
        if (dataset[1]) {
            if (p2n) p2n.textContent = dataset[1].name;
            if (p2s) p2s.textContent = `${dataset[1].score.toLocaleString()} pont`;
        }
        if (dataset[2]) {
            if (p3n) p3n.textContent = dataset[2].name;
            if (p3s) p3s.textContent = `${dataset[2].score.toLocaleString()} pont`;
        }

        // Podium step click handlers
        const step1 = document.querySelector('.podium-step.step-1');
        const step2 = document.querySelector('.podium-step.step-2');
        const step3 = document.querySelector('.podium-step.step-3');

        if (step1) {
            step1.onclick = () => { if (dataset[0]) this.openProfileModal(dataset[0]); };
        }
        if (step2) {
            step2.onclick = () => { if (dataset[1]) this.openProfileModal(dataset[1]); };
        }
        if (step3) {
            step3.onclick = () => { if (dataset[2]) this.openProfileModal(dataset[2]); };
        }

        this.renderLeaderboardList(isClassic);
    }

    renderLeaderboardList(isClassic) {
        const container = document.getElementById('leaderboard-list');
        if (!container) return;
        container.innerHTML = '';

        const dataset = isClassic ? SIMULATED_CLASSIC_LEADERBOARD : SIMULATED_ADVENTURE_LEADERBOARD;
        const myScore = isClassic ? (this.profile.classicBest || 0) : (this.profile.adventureBest || 0);
        const myRank = isClassic ? this.getMyClassicRank() : this.getMyAdventureRank();
        const scoreColor = isClassic ? '#f59e0b' : '#60a5fa';

        // Render simulated players
        dataset.forEach(p => {
            const row = document.createElement('div');
            row.className = 'lb-row';
            row.title = `${p.name} profiljának megtekintése`;
            row.innerHTML = `
                <div class="lb-rank-user">
                    <span class="lb-rank">#${p.rank}</span>
                    <span class="lb-avatar-icon">${p.icon || '🧑‍🚀'}</span>
                    <span class="lb-name">${p.name}</span>
                </div>
                <span class="lb-score" style="color: ${scoreColor};">${p.score.toLocaleString()} pont</span>
            `;
            row.addEventListener('click', () => this.openProfileModal(p));
            container.appendChild(row);
        });

        // Render user row
        const userRow = document.createElement('div');
        userRow.className = 'lb-row player-row';
        userRow.title = 'Saját profilom megnyitása és szerkesztése';
        const userIcon = this.profile.customAvatar ? '📷' : (this.profile.avatarIcon || '🧑‍🚀');
        userRow.innerHTML = `
            <div class="lb-rank-user">
                <span class="lb-rank">#${myRank}</span>
                <span class="lb-avatar-icon">${userIcon}</span>
                <span class="lb-name">Te (${this.profile.playerName || 'Játékos'})</span>
            </div>
            <span class="lb-score" style="color: ${scoreColor}; font-weight: 900;">${myScore.toLocaleString()} pont</span>
        `;
        userRow.addEventListener('click', () => this.openProfileModal(null));
        container.appendChild(userRow);
    }

    getCellElement(r, c) { 
        return this.boardEl ? this.boardEl.querySelector(`.cell[data-row="${r}"][data-col="${c}"]`) : null; 
    }
}

// Instantiate on load
document.addEventListener('DOMContentLoaded', () => { 
    window.app = new BlockBlasterApp(); 
});

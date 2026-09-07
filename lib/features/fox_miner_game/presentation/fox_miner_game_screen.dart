import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/audio/sound_manager.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/storage/progress_repository.dart';
import '../../../core/widgets/bouncy_button.dart';
import '../../../core/widgets/music_toggle_button.dart';
import '../domain/logic/miner_levels_catalog.dart';
import '../domain/models/miner_game_state.dart';
import '../domain/models/miner_level_data.dart';
import 'controllers/fox_miner_controller.dart';
import 'widgets/crystal_break_particles.dart';
import 'widgets/crystal_widget.dart';
import 'widgets/miner_character_button.dart';
import 'widgets/modular_mining_cart.dart';
import 'widgets/miner_victory_dialog.dart';

class FoxMinerGameScreen extends StatefulWidget {
  final MinerLevelData level;

  const FoxMinerGameScreen({
    super.key,
    required this.level,
  });

  @override
  State<FoxMinerGameScreen> createState() => _FoxMinerGameScreenState();
}

class _FoxMinerGameScreenState extends State<FoxMinerGameScreen> {
  late FoxMinerController _controller;
  final ProgressRepository _progressRepository = ProgressRepository();
  bool _dialogShown = false;

  final GlobalKey _crystalKey = GlobalKey();
  final GlobalKey _tensCartKey = GlobalKey();
  final GlobalKey _singlesCartKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = FoxMinerController(
      level: widget.level,
      progressRepository: _progressRepository,
    )..addListener(_onStateChanged);
    SoundManager.instance.startGameMusic();
  }

  @override
  void dispose() {
    _controller.removeListener(_onStateChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted) return;
    setState(() {});

    if (_controller.isCompleted && !_dialogShown) {
      _dialogShown = true;
      Future.delayed(const Duration(milliseconds: 350), () {
        if (!mounted) return;
        _showVictoryDialog();
      });
    }
  }

  void _showVictoryDialog() {
    MinerVictoryDialog.show(
      context,
      level: _controller.level,
      stars: _controller.starsEarned,
      totalSwings: _controller.totalSwings,
      missedSwings: _controller.missedSwings,
      onNextLevel: () {
        Navigator.of(context).pop(); // dismiss dialog
        final next = MinerLevelsCatalog.getNextLevel(_controller.level.levelNumber);
        if (next != null) {
          _dialogShown = false;
          _controller.loadLevel(next);
        } else {
          Navigator.of(context).pop(); // Back to levels
        }
      },
      onReplay: () {
        Navigator.of(context).pop();
        _dialogShown = false;
        _controller.resetLevel();
      },
      onMenu: () {
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      },
    );
  }

  Offset _getCrystalCenter(Size size) {
    final box = _crystalKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) {
      return box.localToGlobal(Offset(box.size.width / 2, box.size.height / 2));
    }
    return Offset(size.width * 0.5, size.height * 0.35);
  }

  Offset _getTensCartPosition(Size size) {
    final box = _tensCartKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) {
      return box.localToGlobal(Offset(box.size.width / 2, box.size.height / 2));
    }
    return Offset(size.width * 0.28, size.height * 0.65);
  }

  Offset _getSinglesCartPosition(Size size) {
    final box = _singlesCartKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) {
      return box.localToGlobal(Offset(box.size.width / 2, box.size.height / 2));
    }
    return Offset(size.width * 0.72, size.height * 0.65);
  }

  void _handleMomMine(BuildContext context) {
    if (_controller.state.canHandoverTen) {
      _handleHandover(context);
      return;
    }

    final prevRemaining = _controller.state.remainingNumber;
    _controller.mineTens();

    if (_controller.lastAction == LastActionType.minedTens) {
      final particles = CrystalBreakParticlesOverlay.of(context);
      final size = MediaQuery.of(context).size;
      final center = _getCrystalCenter(size);
      final dest = _getTensCartPosition(size);

      final variant = ((prevRemaining ~/ 10) % 5) + 1;
      particles?.spawnFlyingCrystal(
        from: center,
        to: dest,
        imagePath: 'assets/images/crystals/crystal_big_$variant.png',
        size: 50,
        colorTint: const Color(0xFF7950F2),
      );

      particles?.spawnBurst(
        origin: center,
        isBigBurst: _controller.isCompleted,
        colorTint: const Color(0xFF7950F2),
      );
    }
  }

  void _handleKidMine(BuildContext context) {
    if (_controller.state.isKidFull) {
      _handleHandover(context);
      return;
    }

    final prevRemaining = _controller.state.remainingNumber;
    _controller.mineSingles();

    if (_controller.lastAction == LastActionType.minedSingles) {
      final particles = CrystalBreakParticlesOverlay.of(context);
      final size = MediaQuery.of(context).size;
      final center = _getCrystalCenter(size);
      final dest = _getSinglesCartPosition(size);

      final variant = ((prevRemaining % 10) % 5) + 1;
      particles?.spawnFlyingCrystal(
        from: center,
        to: dest,
        imagePath: 'assets/images/crystals/crystal_small_$variant.png',
        size: 32,
        colorTint: const Color(0xFF20C997),
      );

      particles?.spawnBurst(
        origin: center,
        isBigBurst: _controller.isCompleted,
        colorTint: const Color(0xFF20C997),
      );
    }
  }

  void _handleHandover(BuildContext context) {
    if (!_controller.state.canHandoverTen) return;

    final particles = CrystalBreakParticlesOverlay.of(context);
    final size = MediaQuery.of(context).size;
    final from = _getSinglesCartPosition(size);
    final to = _getTensCartPosition(size);

    _controller.handoverTen();

    // Visual flight of bundled 10-crystal from Kid's cart to Mom's cart
    particles?.spawnFlyingCrystal(
      from: from,
      to: to,
      imagePath: 'assets/images/crystals/crystal_big_1.png',
      size: 54,
      colorTint: const Color(0xFFFFD43B),
    );

    // Sparkling burst on Kid's cart departing and Mom's cart receiving
    particles?.spawnBurst(
      origin: from,
      isBigBurst: false,
      colorTint: const Color(0xFF20C997),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final strings = l10n.strings;
    final state = _controller.state;

    return CrystalBreakParticlesOverlay(
      child: Builder(
        builder: (ctx) {
          return Scaffold(
            backgroundColor: const Color(0xFFF3EBE1), // Warm mine cave parchment background
            body: SafeArea(
              child: Column(
                children: [
                  // Top Navigation Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        // Back Button
                        BouncyButton(
                          onPressed: () => Navigator.of(context).pop(),
                          backgroundColor: const Color(0xFFFFF3DB),
                          shadowColor: const Color(0xFFE8C88A),
                          padding: EdgeInsets.zero,
                          height: 44,
                          borderRadius: BorderRadius.circular(14),
                          child: const SizedBox(
                            width: 44,
                            height: 44,
                            child: Center(
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: Color(0xFF8A5A2B),
                                size: 22,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Level & Goal Badge
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFF8EC),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFE5CE9F),
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  '${strings.levelNumberLabel} ${state.level.levelNumber}',
                                  style: AppTextStyles.titleSmall.copyWith(
                                    fontSize: 16,
                                    color: const Color(0xFF8A5A2B),
                                  ),
                                ),
                                Container(
                                  width: 1.5,
                                  height: 16,
                                  color: Colors.grey.shade300,
                                ),
                                Row(
                                  children: [
                                    const Text('🎯 ', style: TextStyle(fontSize: 14)),
                                    Text(
                                      '${state.level.targetNumber}',
                                      style: AppTextStyles.titleSmall.copyWith(
                                        fontSize: 16,
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Restart Button
                        BouncyButton(
                          onPressed: () => _controller.resetLevel(),
                          backgroundColor: const Color(0xFFFFF3DB),
                          shadowColor: const Color(0xFFE8C88A),
                          padding: EdgeInsets.zero,
                          height: 44,
                          borderRadius: BorderRadius.circular(14),
                          child: const SizedBox(
                            width: 44,
                            height: 44,
                            child: Center(
                              child: Icon(
                                Icons.refresh_rounded,
                                color: Color(0xFF8A5A2B),
                                size: 22,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 8),

                        // Music Toggle
                        const MusicToggleButton(
                          size: 44,
                          backgroundColor: Color(0xFFFFF3DB),
                          shadowColor: Color(0xFFE8C88A),
                        ),
                      ],
                    ),
                  ),

                  // Swings / Accuracy Ribbon
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.pastelYellow.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.pastelYellowDark,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('⛏️ ', style: TextStyle(fontSize: 13)),
                              Text(
                                '${strings.swingsLabel}: ${state.totalSwings} / ${state.level.optimalSwings}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              if (state.missedSwings > 0) ...[
                                const SizedBox(width: 8),
                                Text(
                                  '(${state.missedSwings} ${strings.missesLabel.toLowerCase()})',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFFE03131),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Central Crystal Display
                  Expanded(
                    child: Center(
                      child: CrystalWidget(
                        key: _crystalKey,
                        levelNumber: state.level.levelNumber,
                        targetNumber: state.level.targetNumber,
                        remainingNumber: state.remainingNumber,
                        tensCollected: state.tensCollected,
                        singlesCollected: state.singlesCollected,
                        isMissed: state.lastAction == LastActionType.missedTens ||
                            state.lastAction == LastActionType.missedSingles,
                      ),
                    ),
                  ),

                  // Mom Fox & Kid Fox Characters with 10-Stage Carts & Handover Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Mom Fox Group (Left): Character on far left + Cart facing center
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: DragTarget<String>(
                              onWillAcceptWithDetails: (details) => state.canHandoverTen,
                              onAcceptWithDetails: (details) => _handleHandover(ctx),
                              builder: (context, candidateData, rejectedData) {
                                return GestureDetector(
                                  key: const ValueKey('miner_button_mom'),
                                  onTap: () => _handleMomMine(ctx),
                                  behavior: HitTestBehavior.opaque,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      MinerCharacterButton(
                                        role: MinerRole.mom,
                                        size: 170,
                                        onTap: () => _handleMomMine(ctx),
                                      ),
                                      const SizedBox(width: 4),
                                      ModularMiningCart(
                                        key: _tensCartKey,
                                        role: MinerRole.mom,
                                        count: state.tensCollected,
                                        width: 165,
                                        height: 140,
                                        onTap: () => _handleMomMine(ctx),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),

                        // Animated Handover Chevrons Button (<<) between Carts
                        if (state.canHandoverTen)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: _HandoverArrowButton(
                              onTap: () => _handleHandover(ctx),
                            ),
                          )
                        else
                          const SizedBox(width: 12),

                        // Kid Fox Group (Right): Cart facing center + Character on far right
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: state.canHandoverTen
                                ? Draggable<String>(
                                    data: 'singles_ten',
                                    feedback: Material(
                                      color: Colors.transparent,
                                      child: Opacity(
                                        opacity: 0.9,
                                        child: ModularMiningCart(
                                          role: MinerRole.kid,
                                          count: state.singlesCollected,
                                          isFull: true,
                                          blockedBadgeLabel: strings.cartFullBadgeLabel,
                                          width: 165,
                                          height: 140,
                                          flipX: true,
                                        ),
                                      ),
                                    ),
                                    childWhenDragging: Opacity(
                                      opacity: 0.35,
                                      child: _buildKidGroup(ctx, state, strings, isDragging: true),
                                    ),
                                    child: _buildKidGroup(ctx, state, strings),
                                  )
                                : _buildKidGroup(ctx, state, strings),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildKidGroup(
    BuildContext ctx,
    MinerGameState state,
    dynamic strings, {
    bool isDragging = false,
  }) {
    return GestureDetector(
      key: const ValueKey('miner_button_kid'),
      onTap: () => _handleKidMine(ctx),
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ModularMiningCart(
            key: _singlesCartKey,
            role: MinerRole.kid,
            count: state.singlesCollected,
            isFull: state.isKidFull,
            blockedBadgeLabel: strings.cartFullBadgeLabel,
            width: 165,
            height: 140,
            flipX: true,
            onTap: () => _handleKidMine(ctx),
          ),
          const SizedBox(width: 4),
          MinerCharacterButton(
            role: MinerRole.kid,
            size: 155,
            flipX: true,
            onTap: () => _handleKidMine(ctx),
          ),
        ],
      ),
    );
  }
}

class _HandoverArrowButton extends StatefulWidget {
  final VoidCallback onTap;

  const _HandoverArrowButton({
    required this.onTap,
  });

  @override
  State<_HandoverArrowButton> createState() => _HandoverArrowButtonState();
}

class _HandoverArrowButtonState extends State<_HandoverArrowButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..repeat(reverse: true);

    _slideAnimation = Tween<double>(begin: 2.0, end: -4.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_slideAnimation.value, 0),
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: BouncyButton(
        key: const ValueKey('handover_arrow_button'),
        onPressed: widget.onTap,
        backgroundColor: const Color(0xFFFF922B),
        shadowColor: const Color(0xFFD9480F),
        borderRadius: BorderRadius.circular(20),
        padding: EdgeInsets.zero,
        height: 48,
        child: Container(
          width: 50,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF922B).withValues(alpha: 0.5),
                blurRadius: 8,
                spreadRadius: 1,
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.keyboard_double_arrow_left_rounded,
              color: Colors.white,
              size: 32,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  blurRadius: 3,
                  offset: Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

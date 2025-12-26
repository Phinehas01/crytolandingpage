import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const CryptoApp());
}

class CryptoApp extends StatelessWidget {
  const CryptoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CryptoOnboardScreen(),
    );
  }
}

class CryptoOnboardScreen extends StatefulWidget {
  const CryptoOnboardScreen({super.key});

  @override
  State<CryptoOnboardScreen> createState() => _CryptoOnboardScreenState();
}

class _CryptoOnboardScreenState extends State<CryptoOnboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    ).animate(_rotationController);

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 0, 0, 0), Color(0xFF1A002F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            _buildBackgroundElements(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    _buildHeaderSection(),
                    Expanded(
                      child: Center(child: _buildCentral3DVisualization()),
                    ),
                    _buildBottonSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundElements() {
    return Stack(
      children: [
        ...List.generate(12, (index) {
          return AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              final angle = _rotationAnimation.value + (index * 0.5);

              final double radius = 80 + index * 20;

              final x =
                  MediaQuery.of(context).size.width / 2 + cos(angle) * radius;
              final y =
                  MediaQuery.of(context).size.height / 2 + sin(angle) * radius;

              return Positioned(
                left: x,
                top: y,
                child: Container(
                  width: 4 + (index % 3) * 2,
                  height: 4 + (index % 3) * 2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.lerp(
                      const Color(0xff6366f1),
                      const Color(0xff885cf6),
                      index / 12,
                    )?.withOpacity(.6),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff6366f1).withOpacity(.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff6366f1), Color(0xff885cf6)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff6366f1).withOpacity(.4),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.currency_bitcoin,
                color: Colors.white,
                size: 48,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "PhinexWallet",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Phinex the future of crypto",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff885cf6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCentral3DVisualization() {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value * 0.1,
          child: SizedBox(
            height: 280,
            width: 280,
            child: Stack(
              children: [
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        alignment: Alignment.center,
                        width: 250,
                        height: 250,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Color(0xff6366f1),
                              Color(0xff885cf6),
                              Color(0xff1e1848),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xff6366f1).withOpacity(.5),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    );
                  },
                ),

                /// -------------- FIXED CENTERED ORBIT ---------------- ///
                ...List.generate(8, (index) {
                  final angle =
                      _rotationAnimation.value + (index * pi / 4);

                  return Align(
                    alignment: Alignment.center,
                    child: Transform.translate(
                      offset: Offset(
                        cos(angle) * 100,
                        sin(angle) * 100,
                      ),
                      child: _buildOrbitingCube(index),
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrbitingCube(int index) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: .8 + (_pulseAnimation.value * 0.3),
          child: Container(
            width: 40 + (index % 3) * 8,
            height: 40 + (index % 3) * 8,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.lerp(
                    Color(0xff6366f1),
                    Color(0xff885cf6),
                    index / 8,
                  )!.withOpacity(.8),
                  Color.lerp(
                    Color(0xff885cf6),
                    Color(0xff6366f1),
                    index / 8,
                  )!.withOpacity(.4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: Colors.white.withOpacity(.2), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff6366f1).withOpacity(.3),
                  blurRadius: 15,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                _getCryptoIcon(index),
                color: Colors.white.withOpacity(.7),
                size: 16 + (index % 3) * 4,
              ),
            ),
          ),
        );
      },
    );
  }

  IconData _getCryptoIcon(int index) {
    final icons = [
      Icons.security,
      Icons.trending_up,
      Icons.account_balance,
      Icons.currency_exchange,
      Icons.monetization_on,
      Icons.account_balance_wallet,
      Icons.savings,
      Icons.analytics,
    ];
    return icons[index % icons.length];
  }

  Widget _buildBottonSection() {
    return Column(
      children: [
        Text(
          "Discover the Future",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8,),
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [Color(0xff6366f1), Color(0xff885cf6)],
          ).createShader(bounds),
          child: Text(
            "Cryptocurrency with PhinexWallet.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ),
        SizedBox(height: 24,),
        Text("Experience seamless crypto transaction with our smooth Phinex wallet app. Fast and secured transaction.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 16,
          color: Color(0xff9ca3af)
        ),
        ),
        SizedBox(height: 40,),
        Row(children: [
          Expanded(
            child: 
          AnimatedBuilder(
            animation: _pulseController,

            builder: (context, child) {
              return Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xff6366f1),
                    Color(0xff885cf6),
                  ]),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff6366f1).withOpacity(.4),
                      blurRadius: 20,
                      offset: Offset(0, 8)
                    )
                  ]
                ),
                child: ElevatedButton(onPressed: (){}, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text("Get Started",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white
                  ),
                  )
                ],)),
              );
            }
          )
          ,)
        ],)
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/detail_cubit.dart';
import '../cubit/detail_state.dart';
import '../../../domain/entities/pokemon_entity.dart';

class DetailScreen extends StatefulWidget {
  final int id;

  const DetailScreen({super.key, required this.id});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _floatAnimation = Tween<double>(
      begin: 0.0,
      end: 10.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Load details
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DetailCubit>().loadPokemonDetail(widget.id);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Modern Design - Helper for Colors
  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return const Color(0xFFFA6555);
      case 'water':
        return const Color(0xFF58ABF6);
      case 'grass':
        return const Color(0xFF48D0B0);
      case 'electric':
        return const Color(0xFFFFCE4B);
      case 'poison':
        return const Color(0xFFA040A0);
      case 'bug':
        return const Color(0xFFA8B820);
      case 'flying':
        return const Color(0xFFA890F0);
      case 'normal':
        return const Color(0xFFA8A878);
      case 'fairy':
        return const Color(0xFFEE99AC);
      case 'psychic':
        return const Color(0xFFF85888);
      case 'fighting':
        return const Color(0xFFC03028);
      case 'rock':
        return const Color(0xFFB8A038);
      case 'ground':
        return const Color(0xFFE0C068);
      case 'ice':
        return const Color(0xFF98D8D8);
      case 'ghost':
        return const Color(0xFF705898);
      case 'dragon':
        return const Color(0xFF7038F8);
      case 'steel':
        return const Color(0xFFB8B8D0);
      case 'dark':
        return const Color(0xFF705848);
      default:
        return const Color(0xFF68A090);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DetailCubit, DetailState>(
        builder: (context, state) {
          if (state is DetailLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is DetailError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is DetailLoaded) {
            final pokemon = state.pokemon;
            final primaryColor = pokemon.types.isNotEmpty
                ? _getTypeColor(pokemon.types.first)
                : Colors.blue;

            return Scaffold(
              backgroundColor: primaryColor,
              body: Stack(
                children: [
                  // Liquid Glass Gradient Overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Background Watermark
                  Positioned(
                    top: 50,
                    right: -50,
                    child: Image.network(
                      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png',
                      width: 300,
                      fit: BoxFit.cover,
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                  Column(
                    children: [
                      // Custom App Bar Area
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildGlassButton(
                                icon: Icons.arrow_back,
                                onTap: () => Navigator.pop(context),
                              ),
                              _buildGlassButton(
                                icon: Icons.favorite_border,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Header Content (Name, Type, Image)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  pokemon.name.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  '#${pokemon.id.toString().padLeft(3, '0')}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              children: pokemon.types.map((type) {
                                return _buildGlassChip(type);
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Floating Image
                      AnimatedBuilder(
                        animation: _floatAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatAnimation.value),
                            child: child,
                          );
                        },
                        child: Hero(
                          tag: pokemon.id,
                          child: CachedNetworkImage(
                            imageUrl: pokemon.imageUrl,
                            height: 250,
                            fit: BoxFit.contain,
                            placeholder: (_, __) => const SizedBox(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // White Sheet with Tabs
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 20,
                                offset: Offset(0, -5),
                              ),
                            ],
                          ),
                          child: DefaultTabController(
                            length: 3,
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                TabBar(
                                  labelColor: Colors.black87,
                                  unselectedLabelColor: Colors.grey,
                                  labelStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  indicatorColor: primaryColor,
                                  indicatorSize: TabBarIndicatorSize.label,
                                  indicatorWeight: 3,
                                  tabs: const [
                                    Tab(text: 'About'),
                                    Tab(text: 'Base Stats'),
                                    Tab(text: 'Evolution'),
                                  ],
                                ),
                                Expanded(
                                  child: TabBarView(
                                    children: [
                                      // About Tab
                                      _buildAboutTab(pokemon),
                                      // Stats Tab
                                      _buildStatsTab(pokemon, primaryColor),
                                      // Evolution Tab
                                      const Center(
                                        child: Text(
                                          'Evolution Chain Coming Soon',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _buildGlassChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAboutTab(PokemonEntity pokemon) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[50], // Very light grey for contrast
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildAboutItem('Height', '${pokemon.height! / 10} m'),
                Container(width: 1, height: 40, color: Colors.grey[300]),
                _buildAboutItem('Weight', '${pokemon.weight! / 10} kg'),
              ],
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            'More details about species and abilities would go here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 14)),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsTab(PokemonEntity pokemon, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Column(
        children: pokemon.stats.map((stat) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Row(
              children: [
                SizedBox(
                  width: 90,
                  child: Text(
                    _formatStatName(stat.name),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 35,
                  child: Text(
                    stat.baseStat.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10), // Fully rounded
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: constraints.maxWidth * (stat.baseStat / 100),
                            decoration: BoxDecoration(
                              color: stat.baseStat >= 50
                                  ? Colors.green
                                  : Colors.redAccent,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatStatName(String name) {
    switch (name) {
      case 'hp':
        return 'HP';
      case 'attack':
        return 'Attack';
      case 'defense':
        return 'Defense';
      case 'special-attack':
        return 'Sp. Atk';
      case 'special-defense':
        return 'Sp. Def';
      case 'speed':
        return 'Speed';
      default:
        return name.toUpperCase();
    }
  }
}

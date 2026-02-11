import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../../../domain/entities/pokemon_entity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

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
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().loadPokemon();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<HomeCubit>().loadPokemon();
    }
  }

  void _checkIfNeedsMoreData(HomeContent content) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (content.pokemonList.isEmpty || content.isLoading) return;

      // If the content is not scrollable (maxScrollExtent is 0 or very small), load more.
      if (_scrollController.hasClients &&
          _scrollController.position.maxScrollExtent < 100) {
        context.read<HomeCubit>().loadPokemon();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Gradient Background for Glassmorphism
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6E48AA), // Purple
              Color(0xFF9D50BB), // Magenta
            ],
          ),
        ),
        child: Column(
          children: [
            // Custom AppBar
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pokedex',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.menu, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  List<PokemonEntity> pokemonList = [];
                  bool isLoading = false;
                  String? error;

                  if (state is HomeLoading && state.isFirstLoad) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  } else if (state is HomeLoading) {
                    pokemonList = state.currentList;
                    isLoading = true;
                  } else if (state is HomeLoaded) {
                    pokemonList = state.pokemonList;
                  } else if (state is HomeError) {
                    pokemonList = state.currentList;
                    error = state.message;
                  }

                  if (pokemonList.isEmpty && error != null) {
                    return Center(
                      child: Text(
                        'Error: $error',
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  _checkIfNeedsMoreData(HomeContent(pokemonList, isLoading));

                  return GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 220,
                          childAspectRatio: 1.3,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                        ),
                    itemCount: pokemonList.length + (isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == pokemonList.length) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        );
                      }
                      final pokemon = pokemonList[index];
                      final typeColor = pokemon.types.isNotEmpty
                          ? _getTypeColor(pokemon.types.first)
                          : Colors.grey;

                      return _AnimatedGlassCard(
                        pokemon: pokemon,
                        typeColor: typeColor,
                        onTap: () => context.go('/pokemon/${pokemon.id}'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeContent {
  final List<PokemonEntity> pokemonList;
  final bool isLoading;
  HomeContent(this.pokemonList, this.isLoading);
}

class _AnimatedGlassCard extends StatefulWidget {
  final PokemonEntity pokemon;
  final Color typeColor;
  final VoidCallback onTap;

  const _AnimatedGlassCard({
    required this.pokemon,
    required this.typeColor,
    required this.onTap,
  });

  @override
  State<_AnimatedGlassCard> createState() => _AnimatedGlassCardState();
}

class _AnimatedGlassCardState extends State<_AnimatedGlassCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: widget.typeColor.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Liquid Glass Shine Effect
              Positioned(
                top: -50,
                left: -50,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),
              // Watermark
              Positioned(
                right: -10,
                bottom: -10,
                child: Image.network(
                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png',
                  width: 90,
                  fit: BoxFit.cover,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.pokemon.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                  color: Colors.black26,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (widget.pokemon.types.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.4),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                widget.pokemon.types.first,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Hero(
                      tag: widget.pokemon.id,
                      child: CachedNetworkImage(
                        imageUrl: widget.pokemon.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                        placeholder: (_, __) => const SizedBox(),
                        errorWidget: (_, __, ___) =>
                            const Icon(Icons.error, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

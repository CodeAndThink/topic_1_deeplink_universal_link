import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/datasources/pokemon_remote_data_source.dart';
import 'data/repositories/pokemon_repository_impl.dart';
import 'domain/repositories/pokemon_repository.dart';
import 'domain/usecases/get_pokemon_detail_usecase.dart';
import 'domain/usecases/get_pokemon_list_usecase.dart';
import 'presentation/detail/cubit/detail_cubit.dart';
import 'presentation/home/cubit/home_cubit.dart';
import 'router/app_router.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // using MultiRepositoryProvider for DI of Repositories and UseCases
    // and MultiBlocProvider for Cubits
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PokemonRemoteDataSource>(
          create: (_) => PokemonRemoteDataSourceImpl(),
        ),
        RepositoryProvider<PokemonRepository>(
          create: (context) => PokemonRepositoryImpl(
            remoteDataSource: context.read<PokemonRemoteDataSource>(),
          ),
        ),
        RepositoryProvider<GetPokemonListUseCase>(
          create: (context) =>
              GetPokemonListUseCase(context.read<PokemonRepository>()),
        ),
        RepositoryProvider<GetPokemonDetailUseCase>(
          create: (context) =>
              GetPokemonDetailUseCase(context.read<PokemonRepository>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>(
            create: (context) => HomeCubit(
              getPokemonListUseCase: context.read<GetPokemonListUseCase>(),
            ),
          ),
          BlocProvider<DetailCubit>(
            create: (context) => DetailCubit(
              getPokemonDetailUseCase: context.read<GetPokemonDetailUseCase>(),
            ),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}

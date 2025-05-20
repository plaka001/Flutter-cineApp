import 'package:cinemapedia/config/constants/enviroment.dart';
import 'package:cinemapedia/domain/datasources/movies_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/infrastructure/mappers/movie_mapper.dart';
import 'package:cinemapedia/infrastructure/models/movidedb/moviedb_reponse.dart';
import 'package:dio/dio.dart';

class MoviedbDatasource extends MovieDataSource {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {'api_key': Enviroment.movieDbKey, 'language': 'es-MX'},
    ),
  );
  @override
  Future<List<Movie>> getNowPlaying({int page = 1}) async {
    final response = await dio.get('/movie/now_playing');

    final moviedbResponse = MovieDbResponse.fromJson(response.data);

    final List<Movie> movies =
        moviedbResponse.results
            .where((element) => element.posterPath != 'no-poster')
            .map((e) => MovieMapper.movieDbToEntity(e))
            .toList();

    return movies;
  }
}

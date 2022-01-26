import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/shared/cubit/states.dart';
import 'package:news/modules/business/business_screen.dart';
import 'package:news/modules/sports/sports_screen.dart';
import 'package:news/modules/science/science_screen.dart';
import 'package:news/shared/network/remote/dio_helper.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitState());

  AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  bool isDark = false;
  List<dynamic> business = [];
  List<dynamic> sports = [];
  List<dynamic> science = [];

  List<Widget> screens = [
    const BusinessScreen(),
    const SportsScreen(),
    const ScienceScreen(),
  ];

  List<String> titles = [
    'Business News',
    'Sport News',
    'Science News',
  ];

  void changeIndex(int index) {
    currentIndex = index;
    if (index == 1) {
      getSports();
    }
    if (index == 2) {
      getScience();
    }
    emit(AppChangeBottomNavBarState());
  }

  void getBusiness() {
    emit(NewsGetBusinessLoadingState());

    DioHelper.getData(
      url: 'v2/top-headlines',
      query: {
        'country': 'eg',
        'category': 'business',
        'apiKey': '9423a0806f2641abb56b84e3052c92b8',
      },
    ).then((value) {
      business = value.data['articles'];
      emit(NewsGetBusinessSuccessState());
    }).catchError((error) {
      emit(NewsGetBusinessErrorState(error.toString()));
    });
  }

  void getSports() {
    emit(NewsGetSportsLoadingState());

    if (sports.isEmpty) {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country': 'eg',
          'category': 'sports',
          'apiKey': '9423a0806f2641abb56b84e3052c92b8',
        },
      ).then((value) {
        sports = value.data['articles'];

        emit(NewsGetSportsSuccessState());
      }).catchError((error) {
        emit(NewsGetSportsErrorState(error.toString()));
      });
    } else {
      emit(NewsGetSportsSuccessState());
    }
  }

  void getScience() {
    emit(NewsGetScienceLoadingState());

    if (science.isEmpty) {
      DioHelper.getData(
        url: 'v2/top-headlines',
        query: {
          'country': 'eg',
          'category': 'science',
          'apiKey': '9423a0806f2641abb56b84e3052c92b8',
        },
      ).then((value) {
        //print(value.data['articles'][0]['title']);
        science = value.data['articles'];

        emit(NewsGetScienceSuccessState());
      }).catchError((error) {
        emit(NewsGetScienceErrorState(error.toString()));
      });
    } else {
      emit(NewsGetScienceSuccessState());
    }
  }

  void changeMode() {
    isDark = !isDark;
    emit(AppChangeModeState());
  }
}

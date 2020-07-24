# flutter_overflow

A StackOverflow client written in Flutter.

_Mainly used for demonstration purposes_

## Changes to _models.dart_

In order to reflect any changes to the data models in _models.dart_, make sure to run the `$ flutter pub run build_runner build` command or run it with the watch command instead.

## StackOverflow Credentials

Due to the purpose of credential files management, the `assets/secret.json` is not pushed to this repo.

To properly set up the environment, please register with StackOverflow to get client_secret, client_id, etc., for running the app.

Alternatively, you can exclude the `login` part and relevant service of the project.


## Release Building

Follow https://flutter.dev/docs/deployment/android#create-a-keystore to create a keystore and configure it in the app to do the release build.
The `build.gradle` file have been adjusted.

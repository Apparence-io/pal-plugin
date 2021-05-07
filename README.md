<p align="center">
	<a href="https://apparence.io/">
		<img src="https://back.apparence.io/media/110/pal-logo.jpeg" width="150px" alt="pal logo">
	</a>
</p>
<p align="center">
    <img src="https://app.bitrise.io/app/83910b8783f1bf6a/status.svg?token=AZYUldjPs6PnJjBYlBfXCg&branch=master"/>
    <a href="https://codecov.io/gl/apparence:pal/pal-flutter">
      <img src="https://codecov.io/gl/apparence:pal/pal-flutter/branch/master/graph/badge.svg?token=VSU0MWER5H"/>
    </a>
    <a href="https://doc.pal-plugin.tech/">
      <img src="https://img.shields.io/static/v1?label=documentation&message=visit&color=orange"/>
    </a>
    <a href="https://pal-plugin.tech/">
      <img src="https://img.shields.io/static/v1?label=website&message=visit&color=purple"/>
    </a>
</p>

# Pal - Flutter onboarding and messages plugin 
- Create guide tours for new users<br/>
- Ask questions and get feedbacks from your users<br/>
- Inform about what’s new in your update<br/>
- Improve your onboardings and app experience using analytics<br/>

**[🎥  Pal introduction in video](https://www.youtube.com/watch?v=RIeeTG928Rc)**

<p align="center">
<img src="https://i.postimg.cc/TwHGZ0r6/anchored.gif" width="150" alt="flutter anchored onboarding screen" />
</p>

## 📱 How it works ?
##### No code editor for all your app screens directly in your app
* Go to a screen where you want to add helper.
* Select your helper type.
* Select and customize your theme.

##### Pal is splitted in two modes
* **Editor**, *create & manage helpers*.
* **Client**, *all created helpers are displayed here*.

##### **Editor mode flow**<br/>
1. Navigate to the screen you want to show your helper.
2. Choose how it should trigger (on first visit, on new update...)
3. Create the helper you want with all texts, colors, fonts...
4. Publish!

##### **Client mode flow**
1. Fetch all onboarding on application start.
2. Trigger an onboarding each time we detect anything that you configured for.
3. Don't show an helper again if user has already seen it.

That's it !

## 🚀&nbsp; Getting started
* Create an **administration** account [**here**](https://app.pal-plugin.tech).<br/>
* Create a **new project** in your dashboard.<br/>
* Get your **token** & **save** it for later.<br/>

<img src="https://i.postimg.cc/YC2nWH5d/token.png" alt="token" />

### Install on your flutter application now 
* Add **Pal** dependency
```yaml
dependencies:
  ...
  pal: ^latest_version
```

* Import **Pal** in the ```main.dart```
```dart
import 'package:palplugin/palplugin.dart';
```

* Wrap **your app** with Pal
```dart
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Pal(
      editorModeEnabled: true,
      appToken: 'REPLACE_WITH_YOUR_APP_TOKEN',
      // --------------------
      // YOUR APP IS HERE
      childApp: MaterialApp(
        navigatorKey: _navigatorKey,
        navigatorObservers: [PalNavigatorObserver.instance()],
        home: YourApp(),
      ),
      // --------------------
    );
  }  
}
```
For GetX users:
```dart
class GetXMyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Pal.fromAppBuilder(
      navigatorKey: navigatorKey,
      editorModeEnabled: false,
      appToken: 'MY_APP_TOKEN_HERE',
      childAppBuilder: (context) => GetMaterialApp(
        navigatorKey: navigatorKey,
        title: 'Pal Plugin Demo',
        navigatorObservers: [PalNavigatorObserver.instance()],
        onGenerateRoute: routes,
      ),
    );
  }
}
```

## 🔥 Configure Events
You can manually specify events within your code so we can use them to let you configure hints with editor.

#### Push a page
(If you use named route, you don't need to use this as we recognize automatically new pages)
```dart
   PalEvents.instance().pushPage(String routeName, {Map<String, String> arguments});
```

## 🎥&nbsp; Youtube Videos

- [Pal introduction](https://www.youtube.com/watch?v=RIeeTG928Rc)
- [How to setup Pal](https://www.youtube.com/watch?v=THJr3ZfFHv8)

## ✨&nbsp; Parameters

| Param | Type  | Description | Required | Default |
| ---   | ---   | ---         | ---      | ---     |
| childApp | ```Widget``` | your application. | ✅ | |
| navigatorKey | ```GlobalKey<NavigatorState>``` | a reference to the navigator key of your application | | ```childApp.navigatorKey``` |
| navigatorObserver | ```PalNavigatorObserver``` | used to manage state of current page | | ```childApp.navigatorObservers``` first entry |
| editorModeEnabled | ```bool``` | enable or Disable the editor mode | | ```true``` |
| textDirection | ```TextDirection``` | text direction of your application | | ```TextDirection.ltr``` |
| appToken | ```String``` | the app token created from the [**admin**](http://demo.pal-plugin.tech) | ✅ | |


## 🙋‍♂️🙋‍♀️ Questions

> *Why I'm getting an error PageCreationException: EMPTY_ROUTE_PROVIDED when creating a new helper?*

When you push a new route, you **always** need to give it an **unique** name if you use ```.push(....)```.

We recommend you to use ```.pushNamed(...)``` method (by using it, Pal know automatically the route name without specified it). But if you prefer using ```.push(...)``` instead, you have to create ```RouteSettings``` like this:

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    settings: RouteSettings(
      name: 'page1', // <- Type here an unique route name
    )),
    builder: (context) => YourNewPage(),
);
```

<br/>

> *Why don't I see all my items as selectable when I create an anchored helper?* 

To detect any widget and get it back in your application we needs you to add a key on every widget you want to be selectable.
For exemple to detect a container :
```dart
...
Container(
  key: ValueKey("myContainerKey"),
  ...
)
```



## 📣&nbsp; Author
<img src="https://en.apparence.io/assets/images/logo.svg" width="64" />
<br />

[Initiated and sponsored by Apparence.io.](https://apparence.io)

## ✨&nbsp; More

[📑 Full documentation](https://doc.pal-plugin.tech)

[🌍 Official website](https://pal-plugin.tech)

package 
{
	import com.facebook.graph.Facebook;
	import com.adobe.serialization.json.JSON;
	import flash.system.Security;
	import flash.events.Event;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import com.facebook.graph.data.FacebookAuthResponse;

	import flash.net.*;//importar foto

	import flash.display.*;//colocar foto no movieclip

	public class FlashWebMain extends Sprite
	{

		protected static const APP_ID:String = "494499000696323";//Place your application id here
		private var _apiSecuredPath:String = "https://graph.facebook.com";//necessários para ir buscar outros objetos (imagem) a outro URL
		private var _apiUnsecuredPath:String = "http://graph.facebook.com";

		public function FlashWebMain()
		{
			welcomeUser.text = "App Init";
			configUI();
		}

		protected function configUI():void
		{
			//Initialize Facebook library
			welcomeUser.text = "Facebook Init";
			Security.loadPolicyFile(_apiSecuredPath + "/crossdomain.xml");
			Security.loadPolicyFile(_apiUnsecuredPath + "/crossdomain.xml");
			Facebook.init(APP_ID, onInit);
		}

		protected function onInit(result:Object, fail:Object):void
		{
			if (result)
			{//already logged in because of existing session
				welcomeUser.text = "onInit, Logged In\n";
				var opts:Object = {scope:"publish_stream, user_photos, user_birthday, user_hometown, user_education_history, user_about_me"};
				Facebook.login(onLogin, opts);

			}
			else
			{
				welcomeUser.text = "onInit, Not Logged In\n";
				var opts:Object = {scope:"publish_stream, user_photos, user_birthday, user_hometown, user_education_history, user_about_me"};
				Facebook.login(onLogin, opts);

			}
		}

		protected function onLogin(result:Object, fail:Object):void
		{
			if (result)
			{//successfully logged in
				welcomeUser.text = "Logged In\n";
				//var targeting:String = "{'countries':['US','IN']}"
				Facebook.api("/me", onCallApi);
			}
			else
			{
				welcomeUser.appendText("Login Failed\n");
			}
		}


		protected function onCallApi(result:Object, fail:Object):void
		{

			welcomeUser.text = result.name;
			welcomeUser3.text = result.birthday;
			welcomeUser4.text = result.hometown.name;
			welcomeUser5.text = result.bio;
			var url = Facebook.getImageUrl(result.id) + "?type=large";

			var loader:Loader = new Loader();
			var request:URLRequest = new URLRequest(url);
			loader.load(request);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadComplete);
		}
		//Vai buscar imagem ao loader e poe-na no mc;
		function loadComplete(event:Event):void
		{
			var li:LoaderInfo = LoaderInfo(event.target);
			var loader:Loader = li.loader;
			fotoPerfil.addChild(loader);
		}
	}
}

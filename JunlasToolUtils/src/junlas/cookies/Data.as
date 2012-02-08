package junlas.cookies {
	import flash.net.*;

    public class Data
    {
        public static var CurrentUserName:String;
        public static var UserProfileData:UserProfile;
        public static var ProfileObject:SharedObject;

        public function Data()
        {
            
        }

        public static function saveUserProfile() : void
        {
            ProfileObject.data["currentUserName"] = CurrentUserName;
            ProfileObject.data["userProfile"] = UserProfileData;
            SharedObjectUtil.save(ProfileObject);
        }

        private static function newUserProfile(param1:String) : void
        {
            CurrentUserName = param1;
            UserProfileData = initDefaultProfile();
            saveUserProfile();
        }

        private static function initDefaultProfile() : UserProfile
        {
            var up:* = new UserProfile();
            return up;
        }

        public static function init() : void
        {
            registerClassAlias("junlas.cookies.UserProfile", UserProfile);
            ProfileObject = SharedObjectUtil.getLocal("Hello_City_snda");
            CurrentUserName = ProfileObject.data["currentUserName"];
            if (CurrentUserName && CurrentUserName != "")
            {
                UserProfileData = UserProfile(ProfileObject.data["userProfile"]);
            }
            else
            {
                newUserProfile("default");
            }
            
        }

    }
}

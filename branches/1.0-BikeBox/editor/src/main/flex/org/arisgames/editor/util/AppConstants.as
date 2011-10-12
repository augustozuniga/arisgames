package org.arisgames.editor.util
{
public class AppConstants
{
    public static const APPLICATION_ENVIRONMENT_UPLOAD_SERVER_URL:String = "http://atsosxdev.doit.wisc.edu/aris/server/services/aris/uploadhandler.php";
//    public static const APPLICATION_ENVIRONMENT_UPLOAD_SERVER_URL:String = "http://www.arisgames.org/stagingserver1/services/aris/uploadHandler.php";
    public static const APPLICATION_ENVIRONMENT_GOOGLEMAP_KEY:String = "ABQIAAAA-Z69V9McvCh02XYNV5UHBBQsvlSBtAWfm4N2P3iTGfWOp-UrmRRTU3pFPQwMJB92SZ3plLjvRpMIIw";
//    public static const APPLICATION_ENVIRONMENT_GOOGLEMAP_KEY:String = "ABQIAAAA-Z69V9McvCh02XYNV5UHBBRloMOfjiI7F4SM41AgXh_4cb6l9xTHRyPNO3mgDcJkTIE742EL8ZoQ_Q";

    // Dynamic Events
    public static const APPLICATIONDYNAMICEVENT_CURRENTSTATECHANGED:String = "ApplicationDynamicEventCurrentStateChanged";
    public static const APPLICATIONDYNAMICEVENT_REDRAWOBJECTPALETTE:String = "ApplicationDynamicEventRedrawObjectPalette";
    public static const DYNAMICEVENT_GEOSEARCH:String = "DynamicEventGeoSearch";
    public static const DYNAMICEVENT_PLACEMARKSELECTED:String = "DynamicEventPlaceMarkSelected";
    public static const DYNAMICEVENT_PLACEMARKREQUESTSDELETION:String = "DynamicEventPlaceMarkRequestsDeletion";
    public static const DYNAMICEVENT_EDITOBJECTPALETTEITEM:String = "EditObjectPaletteItem";
    public static const DYNAMICEVENT_CLOSEOBJECTPALETTEITEMEDITOR:String = "CloseObjectPaletteItemEditor";
    public static const DYNAMICEVENT_CLOSEMEDIAPICKER:String = "CloseMediaPicker";
    public static const DYANMAICEVENT_CLOSEMEDIAUPLOADER:String = "CloseMediaUploader";
    public static const DYNAMICEVENT_CLOSEREQUIREMENTSEDITOR:String = "CloseRequirementsEditor";
    public static const DYNAMICEVENT_REFRESHDATAINREQUIREMENTSEDITOR:String = "RefreshDataInRequirementsEditor";
    public static const DYNAMICEVENT_OPENREQUIREMENTSEDITORMAP:String = "OpenRequirementsEditorMap";
    public static const DYNAMICEVENT_CLOSEREQUIREMENTSEDITORMAP:String = "CloseRequirementsEditorMap";
    public static const DYNAMICEVENT_SAVEREQUIREMENTDUETOMAPDATACHANGE:String = "SaveRequirementDueToMapDataChange";

    // Placemark Content
    public static const CONTENTTYPE_PAGE:String = "Plaque";
    public static const CONTENTTYPE_CHARACTER:String = "Character";
    public static const CONTENTTYPE_ITEM:String = "Item";
    public static const CONTENTTYPE_QRCODEGROUP:String = "QR Code Group";
    public static const CONTENTTYPE_PAGE_VAL:Number = 0;
    public static const CONTENTTYPE_CHARACTER_VAL:Number = 1;
    public static const CONTENTTYPE_ITEM_VAL:Number = 2;
    public static const CONTENTTYPE_QRCODEGROUP_VAL:Number = 3;
    public static const CONTENTTYPE_PAGE_DATABASE:String = "Node";
    public static const CONTENTTYPE_CHARACTER_DATABASE:String = "Npc";
    public static const CONTENTTYPE_ITEM_DATABASE:String = "Item";
    public static const PLACEMARK_DEFAULT_ERROR_RANGE:Number = 20;

    // Label Constants
    public static const BUTTON_LOGIN:String = "Login!";
    public static const BUTTON_REGISTER:String = "Register!";
    public static const RADIO_FORGOTPASSWORD:String = "Forgot Password";
    public static const RADIO_FORGOTUSERNAME:String = "Forgot Username";

    // Media Types
    public static const MEDIATYPE:String = "Media Types";
    public static const MEDIATYPE_IMAGE:String = "Image";
    public static const MEDIATYPE_AUDIO:String = "Audio";
    public static const MEDIATYPE_VIDEO:String = "Video";
    public static const MEDIATYPE_ICON:String = "Icon";
    public static const MEDIATYPE_UPLOADNEW:String = "Upload New";

    // Requirement Types
    public static const REQUIREMENTTYPE_LOCATION:String = "Location";

    // Requirement Options
    public static const REQUIREMENT_PLAYER_HAS_ITEM_DATABASE:String = "PLAYER_HAS_ITEM";
    public static const REQUIREMENT_PLAYER_HAS_ITEM_HUMAN:String = "Player Has Item";
    public static const REQUIREMENT_PLAYER_DOES_NOT_HAVE_ITEM_DATABASE:String = "PLAYER_DOES_NOT_HAVE_ITEM";
    public static const REQUIREMENT_PLAYER_DOES_NOT_HAVE_ITEM_HUMAN:String = "Player Does Not Have Item";
    public static const REQUIREMENT_PLAYER_VIEWED_ITEM_DATABASE:String = "PLAYER_VIEWED_ITEM";
    public static const REQUIREMENT_PLAYER_VIEWED_ITEM_HUMAN:String = "Player Viewed Item";
    public static const REQUIREMENT_PLAYER_HAS_NOT_VIEWED_ITEM_DATABASE:String = "PLAYER_HAS_NOT_VIEWED_ITEM";
    public static const REQUIREMENT_PLAYER_HAS_NOT_VIEWED_ITEM_HUMAN:String = "Player Has Not Viewed Item";
    public static const REQUIREMENT_PLAYER_VIEWED_NODE_DATABASE:String = "PLAYER_VIEWED_NODE";
    public static const REQUIREMENT_PLAYER_VIEWED_NODE_HUMAN:String = "Player Viewed Node";
    public static const REQUIREMENT_PLAYER_HAS_NOT_VIEWED_NODE_DATABASE:String = "PLAYER_HAS_NOT_VIEWED_NODE";
    public static const REQUIREMENT_PLAYER_HAS_NOT_VIEWED_NODE_HUMAN:String = "Player Has Not Viewed Node";
    public static const REQUIREMENT_PLAYER_VIEWED_NPC_DATABASE:String = "PLAYER_VIEWED_NPC";
    public static const REQUIREMENT_PLAYER_VIEWED_NPC_HUMAN:String = "Player Viewed NPC";
    public static const REQUIREMENT_PLAYER_HAS_NOT_VIEWED_NPC_DATABASE:String = "PLAYER_HAS_NOT_VIEWED_NPC";
    public static const REQUIREMENT_PLAYER_HAS_NOT_VIEWED_NPC_HUMAN:String = "Player Has Not Viewed NPC";
    public static const REQUIREMENT_PLAYER_HAS_UPLOADED_MEDIA_ITEM_DATABASE:String = "PLAYER_HAS_UPLOADED_MEDIA_ITEM";
    public static const REQUIREMENT_PLAYER_HAS_UPLOADED_MEDIA_ITEM_HUMAN:String = "Player Has Uploaded Media Item";

    // Defaults
    public static const DEFAULT_ICON_MEDIA_ID_NPC:Number = 1;
    public static const DEFAULT_ICON_MEDIA_ID_ITEM:Number = 2;
    public static const DEFAULT_ICON_MEDIA_ID_PLAQUE:Number = 3;

    /**
     * Constructor
     */
    public function AppConstants()
    {
        super();
    }
}
}
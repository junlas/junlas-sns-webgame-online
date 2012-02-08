package junlas.ui
{
    import flash.text.FontType;
    import flash.text.TextFormat;
    
    import junlas.util.Fonts;
    
    public class TextFormats
    {
        public static var title         : TextFormat = new TextFormat( Fonts.DefaultFontName, 24, 0xFFFFFF, true, null, null, null, null, "left" );
        public static var titleCenter   : TextFormat = new TextFormat( Fonts.DefaultFontName, 24, 0xFFFFFF, true, null, null, null, null, "center" );
        public static var normal        : TextFormat = new TextFormat( Fonts.DefaultFontName, 11, 0xFFFFFF, false );
        public static var normalCenter  : TextFormat = new TextFormat( Fonts.DefaultFontName, 11, 0xFFFFFF, false, null, null, null, null, "center" );
        public static var normalRight   : TextFormat = new TextFormat( Fonts.DefaultFontName, 11, 0xFFFFFF, false, null, null, null, null, "right" );
        public static var bold          : TextFormat = new TextFormat( Fonts.DefaultFontName, 11, 0xFFFFFF, true );
        public static var boldCenter    : TextFormat = new TextFormat( Fonts.DefaultFontName, 11, 0xFFFFFF, true, null, null, null, null, "center" );
        public static var boldRight     : TextFormat = new TextFormat( Fonts.DefaultFontName, 11, 0xFFFFFF, true, null, null, null, null, "right" );
        public static var boldRightGold : TextFormat = new TextFormat( Fonts.DefaultFontName, 11, 0xFFC61C, true, null, null, null, null, "right" );
        public static var boldRightEnh  : TextFormat = new TextFormat( Fonts.DefaultFontName, 11, 0x00FF00, true, null, null, null, null, "right" );
        public static var boldRightNeg  : TextFormat = new TextFormat( Fonts.DefaultFontName, 11, 0xFF0000, true, null, null, null, null, "right" );
        public static var chat          : TextFormat = new TextFormat( Fonts.DefaultFontName, 12, 0xFFFFFF, false );
        public static var larger        : TextFormat = new TextFormat( Fonts.DefaultFontName, 14, 0xFFFFFF, false );
        public static var heading       : TextFormat = new TextFormat( Fonts.DefaultFontName, 14, 0xFFFFFF, true );
        public static var headingGold   : TextFormat = new TextFormat( Fonts.DefaultFontName, 14, 0xFFC61C, true, null, null, null, null, "left" );
        public static var headingCenter : TextFormat = new TextFormat( Fonts.DefaultFontName, 14, 0xFFFFFF, true, null, null, null, null, "center" );
        public static var headingRight  : TextFormat = new TextFormat( Fonts.DefaultFontName, 14, 0xFFFFFF, true, null, null, null, null, "right" );
        public static var headingRightGold  : TextFormat = new TextFormat( Fonts.DefaultFontName, 14, 0xFFC61C, true, null, null, null, null, "right" );
    }
}
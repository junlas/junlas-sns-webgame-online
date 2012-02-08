package junlas.ui
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.filters.GlowFilter;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.text.TextFormatAlign;
    import flash.text.TextFieldAutoSize;
    import junlas.util.Fonts;
    import org.aswing.Icon;
    
    public class FormattedText extends Sprite
    {
        static public var TOOLTIP : uint = 0;
        static public var DIALOG : uint = 1;
        protected var m_width : uint;
        protected var m_iconClass : Class;
        protected var m_lastIcon : Sprite;
        protected var m_insertY : uint;
        protected var m_lastAddedSpace : Boolean;
        protected var m_textAutoSize : String;
        protected var m_textAlign : String;
        protected var m_style : uint;
        protected var m_indent : int;
               
        public function FormattedText( w : uint )
        {
            m_width = w;
            m_style = TOOLTIP;
            leftAlignText();
        }
        
        public function indent( indent : int ) : void
        {
            m_indent += indent;
        }
        
        public function centerText() : void
        {
            m_textAlign = "center";
            m_textAutoSize = "center";
        }
        
        public function leftAlignText() : void
        {
            m_textAlign = "left";
            m_textAutoSize = "left";
        }
        
        public function setIconClass( iconClass : Class ) : void
        {
            m_iconClass = iconClass;
        }
        
        public function addCenteredSprite( sprite : Sprite ) : void
        {
            sprite.x = (width - sprite.width) / 2;
            sprite.y = m_insertY;
            addChild( sprite );
            m_insertY += sprite.height;
        }
        
        public function addColumns( columns : Array, vCenter : Boolean = false ) : void
        {
            var newInsertY : uint = 0;
            var i : uint;
            var maxHeight : uint = 0;

            for( i = 0; i < columns.length; ++i )
                maxHeight = Math.max( maxHeight, columns[i].height );

            var columnStride : uint = (m_width - 10) / columns.length;
            for( i = 0; i < columns.length; ++i )
            {
                var column : Sprite = columns[i];
                var columnCenter : uint = 5 + uint(columnStride * (i + 0.5));
                
                if( vCenter )
                    column.y = m_insertY + (maxHeight - column.height) / 2;
                else
                    column.y = m_insertY;

                column.x = columnCenter - uint(column.width / 2);
                newInsertY = Math.max( newInsertY, m_insertY + column.height );
                addChild( column );

                //outline the columns so you can see them
                // column.graphics.lineStyle( 1, 0xFF0000, 1.0 );
                // column.graphics.drawRect( 0, 0, column.width, column.height );
                // graphics.lineStyle( 1, 0x00FF00, 1.0 );
                // graphics.drawRect( columnCenter, column.y, 1, column.height );
            }
            
            m_insertY = newInsertY;
            m_lastAddedSpace = false;
        }
        
        
        public function addTitle( text : String, color : uint ) : TextField
        {
            var format:TextFormat = new TextFormat;
            format.color = color;
            format.bold = true;
            format.font = Fonts.DefaultFontName;
            format.align = m_textAlign;
            format.size = Fonts.DefaultFontSize;
            
            var textField : TextField = new EmbedTextField;
            textField.defaultTextFormat = format;
            textField.selectable = false;
            var leftGutter : uint = m_lastIcon ? m_lastIcon.x + m_lastIcon.width + 5 : m_indent;
            textField.x = leftGutter;
            textField.y = m_insertY;
            textField.width = m_width - textField.x;
            textField.wordWrap = true;
            textField.autoSize = m_textAutoSize;
            textField.filters = [ new GlowFilter(0x000000, 0, 0, 0, 0 ) ];
            textField.text = text;
            addChild( textField );
            
            m_insertY += textField.height;
            m_lastAddedSpace = false;     
            
            return textField;
        }
        
        public function addHeader( text : String, color : uint ) : TextField
        {
            var format:TextFormat = new TextFormat;
            format.color = color;
            format.bold = true;
            format.font = Fonts.DefaultFontName;
            format.align = m_textAlign;
            format.size = Fonts.DefaultFontSize;
            
            var textField : TextField = new EmbedTextField;
            textField.defaultTextFormat = format;
            textField.selectable = false;
            textField.x = m_indent;
            textField.y = m_insertY;
            textField.width = m_width - textField.x;
            textField.wordWrap = true;
            textField.autoSize = m_textAutoSize;
            textField.filters = [ new GlowFilter(0x000000, 0, 0, 0, 0 ) ];
            textField.text = text;
            addChild( textField );

            m_insertY += textField.height;
            m_lastAddedSpace = false;
            
            return textField;
        }
        
        public function addText( text : String, color : uint ) : void
        {
            var format:TextFormat = new TextFormat;
            format.color = color;
            format.font = Fonts.DefaultFontName;
            format.align = m_textAlign;
            format.size = Fonts.DefaultFontSize;
            format.bold = true;

            var textField : TextField = new EmbedTextField;
            textField.defaultTextFormat = format;
            textField.selectable = false;
            
            var leftGutter : uint = m_lastIcon ? m_lastIcon.x + m_lastIcon.width + 5 : m_indent;
            textField.x = leftGutter;
            textField.y = m_insertY;
            textField.autoSize = m_textAutoSize;
            var maxWidth : uint  = m_width - leftGutter;
            
            if( "center" == m_textAlign )
            {
                textField.wordWrap = true;
                textField.width = maxWidth;
            }
            
            if( -1 == text.search( /[\^\$]/ ) )
                textField.text = text;
            else
            {
                var chunks : Array = text.split( /[\^\$]/ );
                var linkTextFormat : TextFormat = new TextFormat( Fonts.DefaultFontName, Fonts.DefaultFontSize, 0xff0000 );
                var coinTextFormat : TextFormat = new TextFormat( Fonts.DefaultFontName, Fonts.DefaultFontSize, 0x00ff00 );
                textField.text = text.replace( /[\^\$]/g, "" );
                var len : uint = 0;
                for( var i : uint = 0; i < chunks.length - 1; i += 2)
                {
                    var normalPart : String = chunks[i];
                    
                    len += normalPart.length;
                    var textFormat : TextFormat = (text.charAt( len + i ) == "^") ? linkTextFormat : coinTextFormat;
                    
                    var linkPart : String = chunks[i+1];
                    textField.setTextFormat( textFormat, len, len + linkPart.length );
                    len += linkPart.length;
                }
            }

            if( "center" != m_textAlign )
            {
                if( textField.width > maxWidth )
                {
                    textField.wordWrap = true;
                    textField.width = maxWidth;
                }
            }
            textField.filters = [ new GlowFilter(0x000000, 0, 0, 0, 0 ) ];

            addChild( textField );
            m_insertY += textField.height - 2;
            m_lastAddedSpace = false;
        }
        
        public function addKeyValue( key : String, keyColor : uint, value : String, valueColor : uint ) : void
        {
            var labelText : TextField = new EmbedTextField;
            labelText.autoSize = TextFieldAutoSize.LEFT;
            labelText.defaultTextFormat = new TextFormat(Fonts.DefaultFontName, Fonts.DefaultFontSize, keyColor);
            labelText.selectable = false;
            labelText.text = key;

            if( labelText.textWidth > m_width / 2 )
            {
                labelText.wordWrap = true;
                labelText.width = m_width / 2;
            }

            labelText.x = 0;
            labelText.y = m_insertY;
            addChild( labelText );

            var valueText : TextField = new EmbedTextField;
            valueText.autoSize = TextFieldAutoSize.LEFT;
            valueText.defaultTextFormat = new TextFormat(Fonts.DefaultFontName, Fonts.DefaultFontSize, valueColor);
            valueText.selectable = false;
            valueText.text = value;

            if( valueText.textWidth > m_width / 2 )
            {
                valueText.wordWrap = true;
                valueText.width = m_width / 2;
            }

            valueText.x = m_width / 2;
            valueText.y = m_insertY;
            addChild( valueText );

            m_insertY += Math.max( labelText.height, valueText.height );
            m_lastAddedSpace = false;
        }
        
        
        public function addTextBullet( text : String, color : uint ) : void
        {
            var textField : TextField = new EmbedTextField;
            textField.autoSize = TextFieldAutoSize.LEFT;
            textField.defaultTextFormat = new TextFormat( Fonts.DefaultFontName, Fonts.DefaultFontSize, color );
            textField.selectable = false;
            textField.text = text;
            textField.wordWrap = true;
            textField.width = m_width - 10;

            var bullet : Sprite = new Sprite();
            bullet.graphics.beginFill( color, 1 );
            bullet.graphics.drawRect( 0, 0, 4, 4 );
            bullet.graphics.endFill();

            bullet.x = 3;
            bullet.y = m_insertY + 6;
            textField.x = 10;
            textField.y = m_insertY;

            addChild( textField );
            addChild( bullet );
            m_insertY += textField.height;
            m_lastAddedSpace = false;
        }
        
        
        public function addVerticalPadding() : void
        {
            //if( !m_lastAddedSpace )
            //{
                m_insertY += 5;
                m_lastAddedSpace = true;
            //}
        }
        
        public function addVerticalSpace( n : uint ) : void
        {
            m_insertY += n;
        }
        
        public function addRule() : void
        {
            var rule : Sprite = new Sprite();
            rule.graphics.beginFill( 0x000000, 1 );
            rule.graphics.drawRect( 0, 0, m_width, 1 );
            rule.graphics.endFill();

            rule.x = 0;
            rule.y = m_insertY + 2;
            addChild( rule );
            m_insertY += 5;
            m_lastAddedSpace = false;
        }
        
        public function beginRender( style : uint = 0 ) : void
        {
            while( numChildren > 0 )
                removeChildAt( numChildren - 1 );
         
            m_style = style;
            m_lastIcon = null;
            m_lastAddedSpace = false;
            m_insertY = 0;
            leftAlignText();

            graphics.clear();
        }
        
        public function finishRender( ) : void
        {
            return;
            var w : uint = m_width;
            var h : uint = height;
            
            if( height != m_insertY )
               h += 3; // When icon is against bottom edge we need to add extra padding to look good
               
            graphics.beginFill( 0x111122, 1);
            //graphics.lineStyle( 2, 0x000000, 1.0 );
            
            var padding : uint = m_style == TOOLTIP ? 2 : 10;
            //graphics.drawRoundRect( -padding, -padding, w + 2 * padding, h + 2 * padding, 18, 18 );
            graphics.endFill();
            
            //if(!filters.length) filters = DEFAULT_FILTERS;
            
        }

    }
}
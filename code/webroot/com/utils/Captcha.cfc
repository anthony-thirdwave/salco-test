<!--- Document Information -----------------------------------------------------

Title:      Captcha.cfc

Author:     Mark Mandel
Email:      mark@compoundtheory.com

Website:    http://www.compoundtheory.com

Purpose:    writes a captcha

Usage:      

Modification Log:

Name			Date			Description
================================================================================
Mark Mandel		12/01/2006		Created

------------------------------------------------------------------------------->
<cfcomponent name="Captcha" hint="Writes the captcha to a file">
	
<cfscript>
	instance = StructNew();
</cfscript>

<!------------------------------------------- PUBLIC ------------------------------------------->
<cffunction name="init" hint="Constructor" access="public" returntype="Captcha" output="false">
	<cfscript>
		
		return this;
	</cfscript>
</cffunction>

<cffunction name="captchaToFile" hint="Writes the captcha to the designated file path" access="public" returntype="void" output="false">
	<cfargument name="filePath" hint="The absolute path to the file the CAPTCHA is to be written to" type="string" required="Yes">
	<cfargument name="text" hint="The text to display" type="string" required="Yes">
	<cfargument name="width" hint="The width of the image" type="numeric" required="true">
	<cfargument name="height" hint="The height of the image" type="numeric" required="true">
	<cfargument name="fontsize" hint="The font size the text" type="numeric" required="true">
	<cfargument name="leftOffset" hint="The number of pixels of padding to put to the left of the text" type="numeric" required="true">
	<cfargument name="topOffset" hint="The number of pixels of padding to put to the top of the text" type="numeric" required="true">
	<cfargument name="shearXRange" hint="The amount to shear the font on the X axis" type="numeric" required="true">
	<cfargument name="shearYRange" hint="The amount to shear the font on the Y axis"  type="numeric" required="true">	
	
	<cfscript>
		var fileOutputStream = createObject("java", "java.io.FileOutputStream").init(arguments.filePath);		
		
		writeToStream(fileOutputStream,
					  arguments.text,
					  arguments.width,
					  arguments.height,
					  arguments.fontsize,
					  arguments.leftOffset,
					  arguments.topOffset,
					  arguments.shearXRange,
					  arguments.shearYRange);
		    
	    fileOutputStream.flush();
	    fileOutputStream.close();
	</cfscript>	
</cffunction>

<cffunction name="captchaToBinary" hint="Returns the captcha as binary data for use in the cfcontent 'variable' attribute" access="public" returntype="any" output="false">
	<cfargument name="text" hint="The text to display" type="string" required="Yes">
	<cfargument name="width" hint="The width of the image" type="numeric" required="true">
	<cfargument name="height" hint="The height of the image" type="numeric" required="true">
	<cfargument name="fontsize" hint="The font size the text" type="numeric" required="true">
	<cfargument name="leftOffset" hint="The number of pixels of padding to put to the left of the text" type="numeric" required="true">
	<cfargument name="topOffset" hint="The number of pixels of padding to put to the top of the text" type="numeric" required="true">
	<cfargument name="shearXRange" hint="The amount to shear the font on the X axis" type="numeric" required="true">
	<cfargument name="shearYRange" hint="The amount to shear the font on the Y axis"  type="numeric" required="true">		
	<cfscript>
		var byteOutputstream = createObject("java", "java.io.ByteArrayOutputStream").init();
		
		writeToStream(byteOutputstream,
					  arguments.text,
					  arguments.width,
					  arguments.height,
					  arguments.fontsize,
					  arguments.leftOffset,
					  arguments.topOffset,
					  arguments.shearXRange,
					  arguments.shearYRange);
					  
			
		return byteOutputstream.toByteArray();
	</cfscript>
</cffunction>

<!------------------------------------------- PACKAGE ------------------------------------------->

<!------------------------------------------- PRIVATE ------------------------------------------->

<cffunction name="writeToStream" hint="Writes to a outputStream" access="private" returntype="void" output="false">
	<cfargument name="outputStream" hint="Gimme a java.io.OutputStream" type="any" required="Yes">
	<cfargument name="text" hint="The text to display" type="string" required="Yes">
	<cfargument name="width" hint="The width of the image" type="numeric" required="true">
	<cfargument name="height" hint="The height of the image" type="numeric" required="true">
	<cfargument name="fontsize" hint="The font size the text" type="numeric" required="true">
	<cfargument name="LeftOffset" hint="The number of pixels of padding to put to the left of the text" type="numeric" required="true">
	<cfargument name="TopOffset" hint="The number of pixels of padding to put to the top of the text" type="numeric" required="true">
	<cfargument name="shearXRange" hint="The amount to shear the font on the X axis" type="numeric" required="true">
	<cfargument name="shearYRange" hint="The amount to shear the font on the Y axis"  type="numeric" required="true">	
	
	<cfscript>
/* variables */
		var counter = 0;	var characters = 0;		var top = 0;
		var len = 0;		var size = 0;			var left = 0;
		var response = 0;	var char = 0;			var encoder = 0;
		var i = 0;			var encoderParam = 0;

		/* utils */
		var staticArrays = createObject("java", "java.util.Arrays");
		var staticCollections = createObject("java", "java.util.Collections");
		
		
		/* prep image  */
		var dimension = createObject("java", "java.awt.Dimension").init(width, height);	
		var imageType = createObject("java", "java.awt.image.BufferedImage").TYPE_INT_RGB;	
		var bufferedImage = createObject("java", "java.awt.image.BufferedImage").init(JavaCast("int", dimension.getWidth()), JavaCast("int", dimension.getHeight()), imageType);	
		var graphics = bufferedImage.createGraphics();
		
		/* get the fonts */
		var allFontsNotFiltered = staticArrays.asList(createObject("java", "java.awt.GraphicsEnvironment").getLocalGraphicsEnvironment().getAllFonts());
		
		
		
		/* drawing graphics here */
		
		/* background */
		var startColor = createRandomLightGreyScaleColor();
		var endColor = createRandomLightGreyScaleColor();
		
		var gradientPaint = createObject("java", "java.awt.GradientPaint").init(getRandomPointOnBorder(dimension), 
																				startColor, 
																				getRandomPointOnBorder(dimension),  
																				endColor);
		
		var background = createObject("java", "java.awt.Rectangle").init(dimension);
		
		//set list of acceptable fonts
		var acceptList = "Courier New,Tahoma Negreta,Arial Black,MetaBold-Roman,Interstate-RegularItalic,Verdana Negreta,Microsoft Sans Serif,MetaBoldLF-Roman,Lucida Bright Demibold Italic,sansserif.bold,sansserif,Lucida Sans Demibold,Georgia Negreta,Georgia,serif.italic,Palatino Linotype,Arial,Palatino Linotype Negreta,sansserif.italic,Arial Negreta,Tahoma,Lucida Sans Typewriter Bold,serif,Lucida Bright Demibold,Lucida Bright Italic,Courier New Negreta,Times New Roman Negreta,serif.bold,Lucida Console,Times New Roman,Trebuchet MS,Lucida Sans Typewriter Regular,Lucida Bright Regular,Verdana,Trebuchet MS Negreta,Comic Sans MS Negreta,Lucida Sans Regular,Franklin Gothic Demi,Impact,Comic Sans MS";
		//var acceptList = "Arial";
		//set allFonts array to only those fonts in acceptList
		var allFonts = ArrayNew(1);
		for(i=1; i LTE ArrayLen(allFontsNotFiltered); i = i+1){
			if(ListFind(acceptList,allFontsNotFiltered[i].getName())){
				ArrayAppend(allFonts,allFontsNotFiltered[i]);
			}
		}
		
		graphics.setPaint(gradientPaint);
		graphics.fill(background);
		
		/* draw some lines */
		len = randRange(10, 20);
		for(counter = 1; counter lte len; counter = counter + 1)
		{		
			drawRandomLine(graphics, dimension);
		}
		
		/* draw the text in random font characters */
		characters = text.toCharArray();	
		len = ArrayLen(characters);
		
		size = fontsize;
		top = topOffset;
		left = Leftoffset;
		
		staticCollections.shuffle(allFonts);
		for(counter = 1; counter lte len; counter = counter + 1)
		{
			char = characters[counter];
			setNewFont(graphics, allFonts, size, arguments.shearXRange, arguments.shearYRange);
			graphics.setColor(createRandomDarkGreyScaleColor());
	
			//if cannot display, find a font that can
			while(NOT graphics.getFont().canDisplay(char))
			{	
				setNewFont(graphics, allFonts, size, arguments.shearXRange, arguments.shearYRange);
			}		
			graphics.drawString(JavaCast("string", char), JavaCast("int", left), JavaCast("int", top));
			left = left + (2 * graphics.getFontMetrics().charWidth(char));
		}
		
		/* draw a few more lines */
			
		len = randRange(2, round(max(min(width, height) / 20, 3)));  //draw more lines the bigger it is.
		for(counter = 1; counter lte len; counter = counter + 1)
		{		
			drawRandomLine(graphics, dimension);
		}
	
		
	 	encoder = createObject("java", "com.sun.image.codec.jpeg.JPEGCodec").createJPEGEncoder(arguments.outputstream);
	 	encoderParam = encoder.getDefaultJPEGEncodeParam(bufferedImage);
	 	encoderParam.setQuality(JavaCast("float", 0.80), false);
	    encoder.setJPEGEncodeParam(encoderParam);
	    encoder.encode(bufferedImage);
	</cfscript>
</cffunction>

<cffunction name="createRandomLightGreyScaleColor" hint="Creates a random greyscale java.awt.colour" access="private" returntype="any" output="false">
	<cfscript>
		var shade = JavaCast("int", RandRange(255, 160));
		var color = createObject("java", "java.awt.Color").init(shade, shade, shade);
		return color;		
	</cfscript>
</cffunction>

<cffunction name="createRandomDarkGreyScaleColor" hint="Returns a dark greyscale java.awt.color" access="private" returntype="any" output="false">
	<cfscript>
		var shade = JavaCast("int", RandRange(0, 100));		
		var color = createObject("java", "java.awt.Color").init(shade, shade, shade);
		return color;
	</cfscript>
</cffunction>

<cffunction name="getRandomPointOnBorder" hint="Gets a random java.awt.Point on the border" access="private" returntype="any" output="false">
	<cfargument name="dimension" hint="The dimension object" type="any" required="Yes">
	<cfscript>
		var point = createObject("java", "java.awt.Point");
		var height = Javacast("int", arguments.dimension.getHeight());
		var width = JavaCast("int", arguments.dimension.getWidth());
		var choice = randrange(1,4);
		switch (choice)
		{
			case 1: //left side
				point.setLocation(JavaCast("int", 0), JavaCast("int", RandRange(0, height)));
			break;
			case 2: //top side
				point.setLocation(JavaCast("int", RandRange(0, width)), JavaCast("int", 0));
			break;
			case 3: //right side
				point.setLocation(width, RandRange(0, height));
			break;
			case 4:	//bottom side
				point.setLocation(RandRange(0, width), height);
			break;		
		}
		
		return point;			
	</cfscript>
</cffunction>

<cffunction name="setNewFont" hint="Sets a new font in the graphics lib" access="private" returntype="void" output="false">
	<cfargument name="graphics" hint="The graphics" type="any" required="Yes">
	<cfargument name="fontCollection" hint="The current font collection" type="any" required="Yes">
	<cfargument name="size" hint="The size of the font" type="numeric" required="Yes">
	<cfargument name="shearXRange" hint="The shear x range" type="numeric" required="Yes">
	<cfargument name="shearYRange" hint="The shear y range" type="numeric" required="Yes">
	<cfscript>
		var font = 0;
		var staticCollections = createObject("java", "java.util.Collections");
						
		staticCollections.rotate(arguments.fontCollection, 1);
		//apply transform twice, just for fun
		font = arguments.fontCollection[1].deriveFont(JavaCast("float", arguments.size)).deriveFont(getRandomTransformation(arguments.shearXRange, arguments.shearYRange)).deriveFont(getRandomTransformation(arguments.shearXRange, arguments.shearYRange));
		arguments.graphics.setFont(font);		
	</cfscript>
</cffunction>

<cffunction name="getRandomTransformation" hint="Gets a random transformation" access="private" returntype="any" output="false">
	<cfargument name="shearXRange" hint="The shear x range" type="numeric" required="Yes">
	<cfargument name="shearYRange" hint="The shear y range" type="numeric" required="Yes">
	<cfscript>
		//create a slightly random affine transform
		var transformation = createObject("java", "java.awt.geom.AffineTransform").init();
		var shearx = RandRange(-1 * arguments.shearXRange, arguments.shearXRange) / 100;
		var sheary = RandRange(-1 * arguments.shearYRange, arguments.shearYRange) / 100;
		transformation.shear(shearx, sheary);
		
		return transformation;
	</cfscript>
</cffunction>

<cffunction name="drawRandomLine" hint="draws a random line" access="private" returntype="void" output="false">
	<cfargument name="graphics" hint="The graphics" type="any" required="Yes">
	<cfargument name="dimension" hint="The dimension object" type="any" required="Yes">
	<cfscript>
		var point1 = getRandomPointOnBorder(arguments.dimension);
		var point2 = getRandomPointOnBorder(arguments.dimension);
		var staticColor = createObject("java", "java.awt.Color");
		
		arguments.graphics.setColor(staticColor.white);
		
		arguments.graphics.drawLine(
			JavaCast("int", point1.getX()), 
			JavaCast("int", point1.getY()), 
			JavaCast("int", point2.getX()), 
			JavaCast("int", point2.getY()));
	
	</cfscript>
</cffunction>

</cfcomponent>
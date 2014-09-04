<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.elsevier.com/xml/svapi/article/dtd"
	xmlns:bk="http://www.elsevier.com/xml/bk/dtd"
	xmlns:cals="http://www.elsevier.com/xml/common/cals/dtd"
	xmlns:ce="http://www.elsevier.com/xml/common/dtd"
	xmlns:ja="http://www.elsevier.com/xml/ja/dtd"
	xmlns:mml="http://www.w3.org/1998/Math/MathML"
    xmlns:sa="http://www.elsevier.com/xml/common/struct-aff/dtd"
	xmlns:sb="http://www.elsevier.com/xml/common/struct-bib/dtd"
	xmlns:tb="http://www.elsevier.com/xml/common/table/dtd"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:xocs="http://www.elsevier.com/xml/xocs/dtd"
	xmlns:xoe="http://www.elsevier.com/xml/xoe/dtd"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:prism="http://prismstandard.org/namespaces/basic/2.0/"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
	
>

	<!-- The following variables has to be defined. Either in this file or in
		 the calling code. -->

	<!-- Whether the guest mode is active. -->
	<xsl:variable name="guest" select="''" />

	<!-- Used for generating links to image attachments. -->
	<xsl:variable name="base_url" select="'/image.php?i=http://127.0.0.1/'" />

	<!-- Used for generating links to the figure images. -->
	<xsl:variable name="image_url" select="'/image.php?i=http://ars.els-cdn.com/content/image/'" />

	<!-- Used for generating links to glyph images. -->
	<xsl:variable name="glyph_url" select="'/image.php?i=http://cdn.els-cdn.com/sd/entities/'" />

	<!-- Used for the elsevier logo. -->
	<xsl:variable name="logo_url" select="'http://cdn.els-cdn.com/sd/elsevier.gif'" />

	<!-- Used by non-serial.xsl and serial.xml -->
	<xsl:variable name="publication_url">
		<xsl:for-each select="$meta">
			<xsl:choose>
				<xsl:when test="'JL' = xocs:content-type">
					<xsl:text>http://www.sciencedirect.com/science/journal/</xsl:text>
					<xsl:apply-templates select="xocs:issns/xocs:issn-primary-unformatted"/>
				</xsl:when>
				<xsl:when test="'BS' = xocs:content-type">
					<xsl:text>http://www.sciencedirect.com/science/bookseries/</xsl:text>
					<xsl:apply-templates select="xocs:issns/xocs:issn-primary-unformatted"/>
				</xsl:when>
				<xsl:when test="'HB' = xocs:content-type">
					<xsl:text>http://www.sciencedirect.com/science/handbooks/</xsl:text>
					<xsl:apply-templates select="xocs:issns/xocs:issn-primary-unformatted"/>
				</xsl:when>
				<xsl:when test="'BK' = xocs:content-type">
					<xsl:text>http://www.sciencedirect.com/science/book/</xsl:text>
					<xsl:apply-templates select="xocs:isbns/xocs:isbn-primary-unformatted"/>
				</xsl:when>
				<xsl:when test="'RW' = xocs:content-type">
					<xsl:text>http://www.sciencedirect.com/science/referenceworks/</xsl:text>
					<xsl:apply-templates select="xocs:isbns/xocs:isbn-primary-unformatted"/>
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
	</xsl:variable>

	<xsl:variable name="sizeAttr" select="1" />

	<xsl:variable name="meta" select="//xoe:documents/xocs:doc/xocs:meta" />
	<xsl:variable name="doi" select="$meta/xocs:doi" />
	<xsl:variable name="eid" select="$meta/xocs:eid" />

	<xsl:include href="inc_templates.xsl" />
	<xsl:include href="inc_common_elements.xsl" />
	<xsl:include href="inc_xocs.xsl" />
	<xsl:include href="inc_serial.xsl" />
	<xsl:include href="inc_nonserial.xsl" />
	<xsl:include href="inc_cross-refs.xsl" />
	<xsl:include href="inc_para.xsl" />

	<xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en"><meta http-equiv="Content-Type" content="text/html; charset=UTF-8" /><meta name="viewport" content="initial-scale=1, user-scalable=no" /><head>
            	[[js]]
                <link id="favicon" rel="shortcut icon" type="image/png" href="/Lib/Img/cornerstone_80x80.png" />
                [[css]]
			</head>
			<body>
				<div id="mainView" class="article">
					<!--<xsl:apply-templates select="/xoe:documents/xocs:doc/xocs:serial-item" />-->
					<!--<xsl:apply-templates select="/xoe:documents/xocs:doc/xocs:nonserial-item" />-->
                    <xsl:apply-templates select="//xocs:doc/xocs:serial-item/ja:article" />
					<xsl:apply-templates select="//xocs:doc/xocs:nonserial-item/ja:article" />
					<xsl:apply-templates select="$meta/xocs:copyright-line" />
					<xsl:apply-templates select="/xoe:documents/xocs:doc/error-document" />
					<xsl:apply-templates select="/xoe:documents/error-document/error" />
				</div>
                
			</body>
		</html>
	</xsl:template>

	<xsl:template match="error-document">
		<div class="error">
			<span class="icon error">&#160;</span>
			<xsl:apply-templates select="error/@code" />
			<xsl:text>: </xsl:text>
			<xsl:apply-templates select="error" />
		</div>
	</xsl:template>

</xsl:stylesheet>

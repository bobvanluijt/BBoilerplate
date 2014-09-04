<?xml version="1.0"?>
<!-- @copyright Elsevier UCD -->
<!-- @author Stefan Kuip -->
<!-- @date 2013-09-16 -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:bk="http://www.elsevier.com/xml/bk/dtd"
	xmlns:cals="http://www.elsevier.com/xml/common/cals/dtd"
	xmlns:ce="http://www.elsevier.com/xml/common/dtd"
	xmlns:ja="http://www.elsevier.com/xml/ja/dtd"
	xmlns:mml="http://www.w3.org/1998/Math/MathML"
	xmlns:sb="http://www.elsevier.com/xml/common/struct-bib/dtd"
	xmlns:tb="http://www.elsevier.com/xml/common/table/dtd"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:xocs="http://www.elsevier.com/xml/xocs/dtd"
	xmlns:xoe="http://www.elsevier.com/xml/xoe/dtd"
	exclude-result-prefixes="bk cals ce ja mml sb tb xlink xocs xoe"
	>
	<xsl:output encoding="UTF-8" method="xml" omit-xml-declaration="yes" indent="yes" />

	<xsl:variable name="issue_url">
		<xsl:value-of select="$publication_url" />
		<xsl:text>/</xsl:text>
		<xsl:apply-templates select="$meta/xocs:vol-first"/>
		<xsl:if test="$meta/xocs:iss-first">
			<xsl:text>/</xsl:text>
			<xsl:apply-templates select="$meta/xocs:iss-first"/>
		</xsl:if>
	</xsl:variable>

	<xsl:template match="xocs:serial-item">

		<div class="head">
			<div class="publisher">
				<xsl:call-template name="image">
					<xsl:with-param name="alt" select="'Publisher logo'" />
					<xsl:with-param name="height" select="80" />
					<xsl:with-param name="src" select="$logo_url" />
				</xsl:call-template>
			</div>
			<div class="publication">
				<div class="title">
					<a href="{$publication_url}" title="Go to {$meta/xocs:srctitle} on SciVerse ScienceDirect">
						<xsl:apply-templates select="$meta/xocs:srctitle" />
					</a>
				</div>
				<p class="volume-issue">
					<xsl:for-each select="$meta/xocs:vol-iss-suppl-text">
						<a class="js_intern" href="{$issue_url}" title="Go to table of contents for this volume/issue">
							<xsl:apply-templates/>
						</a>
					</xsl:for-each>
					<xsl:if test="$meta/xocs:vol-iss-suppl-text and $meta/xocs:cover-date-text">
						<xsl:text>, </xsl:text>
					</xsl:if>
					<xsl:for-each select="$meta/xocs:cover-date-text">
						<xsl:apply-templates/>
					</xsl:for-each>
					<xsl:for-each select="$meta/xocs:pages">
						<xsl:choose>
							<xsl:when test="1 = position()">, Pages </xsl:when>
							<xsl:otherwise>, </xsl:otherwise>
						</xsl:choose>
						<xsl:apply-templates select="xocs:first-page" />
						<xsl:if test="xocs:last-page">
							<xsl:text>–</xsl:text>
							<xsl:apply-templates select="xocs:last-page" />
						</xsl:if>
					</xsl:for-each>
				</p>
				<xsl:if test="$meta/xocs:aip-text">
					<p class="aip">
						<xsl:apply-templates select="$meta/xocs:aip-text" />
						<xsl:text> — </xsl:text>
						<a>
							<xsl:variable name="aip" select="$meta/xocs:aip-text" />
							<xsl:attribute name="href">
								<xsl:text>#</xsl:text>
								<xsl:choose>
									<xsl:when test="contains($aip, 'Accepted Manuscript')">aipAcceptedManuscript</xsl:when>
									<xsl:when test="contains($aip, 'Uncorrected Proof')">aipUncorrectedProof</xsl:when>
									<xsl:when test="contains($aip, 'Corrected Proof')">aipCorrectedProof</xsl:when>
									<xsl:when test="contains($aip, 'Withdrawn Article')">aipwithdrawnArticle</xsl:when>
								</xsl:choose>
							</xsl:attribute>
							<xsl:text>Note to users</xsl:text>
						</a>
					</p>
				</xsl:if>
			</div>
			<div class="cover">
				<a href="{$publication_url}" title="Go to {$meta/xocs:srctitle} on SciVerse ScienceDirect">
					<xsl:call-template name="image">
						<xsl:with-param name="alt" select="''" />
						<xsl:with-param name="class" select="'cover'" />
						<xsl:with-param name="height" select="80" />
						<xsl:with-param name="src" select="concat($image_url, 'S', //xocs:issns/xocs:issn-primary-unformatted, '.gif')" />
					</xsl:call-template>
				</a>
			</div>
		</div>


		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="ja:article">
		<xsl:apply-templates />
		<xsl:apply-templates select="ja:head/ce:article-footnote" />
		<xsl:apply-templates select="ja:head/ce:author-group/ce:correspondence" />
		<xsl:apply-templates select=".//ce:footnote" mode="render"/>
	</xsl:template>

	<xsl:template match="ja:simple-article|ja:exam">
		<xsl:apply-templates />
		<xsl:apply-templates select="ja:simple-head/ce:article-footnote" />
		<xsl:apply-templates select="ja:simple-head/ce:author-group/ce:correspondence" />
		<xsl:apply-templates select=".//ce:footnote" mode="render"/>
	</xsl:template>

	<xsl:template match="ja:book-review">
		<xsl:apply-templates />
		<xsl:apply-templates select="ja:book-review-head/ce:article-footnote" />
		<xsl:apply-templates select="ja:book-review-head/ce:author-group/ce:correspondence" />
		<xsl:apply-templates select=".//ce:footnote" mode="render"/>
	</xsl:template>

	<xsl:template match="ja:head|ja:simple-head|ja:book-review-head">
		<!--<xsl:apply-templates select="ce:article-footnote" />-->
		<xsl:apply-templates select="ce:markers" />
		<xsl:apply-templates select="ce:dochead" />
		<xsl:apply-templates select="ce:label" />
		<xsl:apply-templates select="ce:title" />
		<xsl:apply-templates select="ce:subtitle" />
		<xsl:apply-templates select="ce:alt-title" />
		<xsl:apply-templates select="ce:alt-subtitle" />
		<xsl:apply-templates select="sb:reference" /><!-- FIXME: book-review -->
		<xsl:apply-templates select="ce:other-ref" /><!-- FIXME: book-review -->
		<xsl:apply-templates select="ce:presented" />
		<xsl:apply-templates select="ce:dedication" />
		<xsl:apply-templates select="ce:author-group" />
		<xsl:apply-templates select="../ja:item-info/ce:preprint" />

		<xsl:if test="ce:date-received|ce:date-revised|ce:date-accepted|ce:miscellaneous">
			<ul class="articleDates">
				<li>
					<xsl:apply-templates select="ce:date-received" />
					<xsl:apply-templates select="ce:date-revised" />
					<xsl:apply-templates select="ce:date-accepted" />
					<xsl:apply-templates select="ce:miscellaneous" />
				</li>
			</ul>
		</xsl:if>

		<ul class="articleInfo">
			<li class="doi">
				<xsl:apply-templates select="$doi" />
			</li>
		</ul>

		<!--
			 <xsl:text>[PLACEHOLDER:REFERS-TO/REFERRED-TO-BY]</xsl:text>
		 -->

		<xsl:if test="ce:abstract|ce:keywords|ce:stereochem">
			<hr class="before" />
			<xsl:apply-templates select="ce:abstract" />
			<xsl:apply-templates select="ce:keywords" />
			<xsl:apply-templates select="ce:stereochem" />
		</xsl:if>

		<hr class="after" />
	</xsl:template>

	<xsl:template match="ja:item-info">
		<!-- TODO -->
	</xsl:template>

</xsl:stylesheet>

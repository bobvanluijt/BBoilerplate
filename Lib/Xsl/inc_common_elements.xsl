<?xml version="1.0"?>
<!-- @copyright Elsevier UCD -->
<!-- @author Stefan Kuip -->
<!-- @date 2013-09-16 -->

<xsl:stylesheet version="1.0"
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
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="bk cals ce ja mml sb tb xlink xocs xoe"
	>

	<!-- Key database for finding and generating id's -->
	<xsl:key name="type-name-id" use="concat(xocs:attachment-type,xocs:file-basename)"
		match="//xocs:attachment" />
	<xsl:key name="basename-id" use="xocs:file-basename"
		match="//xocs:attachment" />

<!--
	<xsl:template match="ce:text"><xsl:apply-templates /></xsl:template>
	<xsl:template match="ce:textfn"><xsl:apply-templates /></xsl:template>
	<xsl:template match="ce:textref"><xsl:apply-templates /></xsl:template>
	<xsl:template match="ce:label"><xsl:apply-templates /></xsl:template> 
	<xsl:template match="ce:section-title"><xsl:apply-templates /></xsl:template>
-->

	<!-- Don't use, use the one in the xocs data! -->
	<xsl:template match="ce:pii"/>
	<xsl:template match="ce:isbn"/>
	<xsl:template match="ce:issn"/>
	<xsl:template match="ce:doi">
		<a class="extern js_extern">
			<xsl:attribute name="href">
				<xsl:text>http://dx.doi.org/</xsl:text>
				<xsl:apply-templates />
			</xsl:attribute>
			<xsl:apply-templates />
		</a>
	</xsl:template>

	<!-- Handled extern together with the referred to by articles. -->
	<xsl:template match="ce:document-thread" />
	<xsl:template match="ce:refers-to-document"/>

	<!-- Only used for copyright inside the ce:figure, ce:textbox and
		 ce:e-component elements. -->
	<xsl:template match="ce:copyright">
		<dd class="copyright">
			<xsl:apply-templates />
		</dd>
	</xsl:template>

	<!-- xocs:copyright is used for serial and non-serial content -->
	<xsl:template match="ce:copyright-line"/>

	<xsl:template match="ce:imprint">
		<!-- XXX: Not printed and no documents found. -->
	</xsl:template>

	<xsl:template match="ce:edition">
		<!-- XXX: Not printed and no documents found. -->
	</xsl:template>

	<!-- Doctopics aren't rendered in the HTML -->
	<xsl:template match="ce:doctopics"/>
	<xsl:template match="ce:doctopic"/>

	<xsl:template match="ce:preprint">
		<p class="preprint">
			<xsl:text>This article is registered under preprint number </xsl:text>
			<xsl:apply-templates select="ce:inter-ref" />
		</p>
	</xsl:template>

	<xsl:template match="ce:article-footnote">
		<dl id="{@id}" class="footnote">
			<xsl:if test="ce:label">
				<dt>
					<a href="#{@id}">
						<xsl:value-of select="ce:label" />
					</a>
				</dt>
			</xsl:if>
			<dd>
				<xsl:apply-templates select="ce:note-para" />
			</dd>
		</dl>
	</xsl:template>

	<xsl:template match="ce:markers">
	</xsl:template>

	<xsl:template match="ce:marker[@altimg]">
		<xsl:text> </xsl:text>
		<xsl:call-template name="renderFilename">
			<xsl:with-param name="id" select="@altimg" />
			<xsl:with-param name="class" select="'marker'" />
			<xsl:with-param name="altText" select="@alt" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="ce:dochead">
		<!-- Nested ce:dochead elements are NOT rendered.-->
		<!--<div class="publicationType">-->
		<!--	<xsl:apply-templates select="ce:textfn"/>-->
		<!--</div>-->
	</xsl:template>

	<xsl:template match="ce:title">
		<h1>
			<xsl:apply-templates select="../ce:markers/ce:marker" />

			<xsl:if test="../ce:label">
				<xsl:apply-templates select="../ce:label"/>
				<xsl:text>. </xsl:text>
			</xsl:if>
			<xsl:apply-templates />

			<xsl:for-each select="../ce:article-footnote[ce:label]">
				<xsl:text> </xsl:text>
				<a href="#{@id}">
					<xsl:apply-templates select="ce:label" />
				</a>
			</xsl:for-each>
		</h1>
	</xsl:template>

	<xsl:template match="ce:alt-title">
		<div class="articleTitle">
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:template match="ce:subtitle">
		<div class="articleSubTitle">
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:template match="ce:alt-subtitle">
		<div class="articleSubTitle">
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:template match="ce:presented">
		<div class="presented">
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:template match="ce:dedication">
		<div class="dedicated">
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:template match="ce:author-group">
		<div class="articlehead">
			<ul class="authorGroup">
				<xsl:for-each select="ce:collaboration|ce:author">
					<li>
						<xsl:apply-templates select="."/>

						<xsl:if test="last() &gt; position()">
							<xsl:choose>
								<xsl:when test="last() - 1 = position()"> and </xsl:when>
								<xsl:otherwise>, </xsl:otherwise>
							</xsl:choose>
						</xsl:if>
					</li>
				</xsl:for-each>
			</ul>

			<xsl:if test="ce:affiliation">
				<ul class="affiliation">
					<xsl:apply-templates select="ce:affiliation" />
				</ul>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="ce:collaboration"><!-- FIXME -->
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="ce:collab-aff"><!-- FIXME -->
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="ce:author">
		<!--<a href="#{@id}">-->
			<xsl:if test="ce:given-name">
				<xsl:apply-templates select="ce:given-name"/>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:apply-templates select="ce:surname"/>
		<!--</a>-->

		<xsl:if test="ce:suffix">
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="ce:suffix"/>
		</xsl:if>

		<xsl:if test="ce:degrees">
			<xsl:text> </xsl:text>
			<xsl:apply-templates select="ce:degrees"/>
		</xsl:if>

		<xsl:if test="ce:cross-ref">
			<xsl:text> </xsl:text>
			<xsl:for-each select="ce:cross-ref">
				<xsl:if test="1 != position()">
					<sup>,</sup>
				</xsl:if>
				<xsl:apply-templates />
			</xsl:for-each>
		</xsl:if>

		<xsl:if test="ce:e-address">
			<xsl:for-each select="ce:e-address">
				<xsl:choose>
					<xsl:when test="not(../ce:cross-ref) and 1 = position()">
						<xsl:text> </xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<sup>,</sup>
					</xsl:otherwise>
				</xsl:choose>
				<sup>
					<xsl:apply-templates select="." />
				</sup>
			</xsl:for-each>
		</xsl:if>

		<xsl:apply-templates select="ce:roles|@biographyid" />

	</xsl:template>

	<xsl:template match="ce:author/@biographyid">
		<!--
			<span class="vitae">
				<xsl:text> [</xsl:text>
				<a href="#{.}">Author Vitae</a>
				<xsl:text>]</xsl:text>
			</span>
		-->
	</xsl:template>

<!-- No special action required.
	<xsl:template match="ce:initials"><xsl:apply-templates /></xsl:template> 
	<xsl:template match="ce:indexed-name"><xsl:apply-templates /></xsl:template> 
	<xsl:template match="ce:degrees"><xsl:apply-templates /></xsl:template> 
	<xsl:template match="ce:given-name"><xsl:apply-templates /></xsl:template> 
	<xsl:template match="ce:surname"><xsl:apply-templates /></xsl:template> 
	<xsl:template match="ce:suffix"><xsl:apply-templates /></xsl:template> 
	<xsl:template match="ce:ranking"><xsl:apply-templates /></xsl:template> 
-->

	<xsl:template match="ce:roles">
		<xsl:text> (</xsl:text>
		<xsl:apply-templates />
		<xsl:text>)</xsl:text>
	</xsl:template>

	<xsl:template match="ce:correspondence">
		<dl id="{@id}" class="footnote">
			<dt class="label">
				<xsl:apply-templates select="ce:label" />
			</dt>
			<dd>
				<xsl:apply-templates select="ce:text"/>
			</dd>
		</dl>
	</xsl:template>

	<xsl:template match="ce:e-address">
		<xsl:choose>
			<xsl:when test="'url' = @type">
				<a href="{.}"  title="Website from the corresponding author">www
				</a>
			</xsl:when>
			<xsl:otherwise>
				<a href="mailto:{.}"  title="E-mail the corresponding author">
					<img src="/image.php?i=http://cdn.els-cdn.com/sd/entities/REemail.gif" />
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="ce:affiliation">
		<li id="{@id}">
			<xsl:if test="ce:label">
				<sup>
					<xsl:apply-templates select="ce:label"/>
				</sup>
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:value-of select="ce:textfn"/>
		</li>
	</xsl:template>

	<!-- <xsl:template match="ce:editors"><xsl:apply-templates /></xsl:template> -->

	<xsl:template match="ce:date-received">
		<xsl:text>Received </xsl:text>
		<xsl:apply-templates select="@day" />
		<xsl:apply-templates select="@month" />
		<xsl:apply-templates select="@year" />
		<xsl:text>. </xsl:text>
	</xsl:template>

	<xsl:template match="ce:date-revised">
		<xsl:if test="not(preceding-sibling::ce:date-revised)">
			<xsl:text>Revised </xsl:text>
		</xsl:if>

		<xsl:if test="preceding-sibling::ce:date-revised">
			<xsl:choose>
				<xsl:when test="following-sibling::ce:date-revised">, </xsl:when>
				<xsl:otherwise> and </xsl:otherwise>
			</xsl:choose>
		</xsl:if>

		<xsl:apply-templates select="@day" />
		<xsl:apply-templates select="@month" />
		<xsl:apply-templates select="@year" />

		<xsl:if test="not(following-sibling::ce:date-revised)">
			<xsl:text>. </xsl:text>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ce:date-accepted">
		<xsl:text>Accepted </xsl:text>
		<xsl:apply-templates select="@day" />
		<xsl:apply-templates select="@month" />
		<xsl:apply-templates select="@year" />
		<xsl:text>. </xsl:text>
	</xsl:template>

	<xsl:template match="@month">
		<xsl:choose>
			<xsl:when test=" 1 = ."> Januari</xsl:when>
			<xsl:when test=" 2 = ."> February</xsl:when>
			<xsl:when test=" 3 = ."> March</xsl:when>
			<xsl:when test=" 4 = ."> April</xsl:when>
			<xsl:when test=" 5 = ."> May</xsl:when>
			<xsl:when test=" 6 = ."> June</xsl:when>
			<xsl:when test=" 7 = ."> July</xsl:when>
			<xsl:when test=" 8 = ."> August</xsl:when>
			<xsl:when test=" 9 = ."> September</xsl:when>
			<xsl:when test="10 = ."> October</xsl:when>
			<xsl:when test="11 = ."> November</xsl:when>
			<xsl:when test="12 = ."> December</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="@year">
		<xsl:text> </xsl:text>
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="ce:miscellaneous">
		<xsl:apply-templates />
		<!-- <xsl:text>. </xsl:text> -->
	</xsl:template>

	<xsl:template match="ce:abstract">
		<div class="abstract" id="{@id}">
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:template match="ce:abstract/ce:section-title">
		<h2>
			<xsl:apply-templates />
		</h2>
	</xsl:template>

	<xsl:template match="ce:abstract-sec">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="ce:abstract-sec/ce:section-title">
		<h3 id="{../@id}">
			<xsl:apply-templates />
		</h3>
	</xsl:template>

	<xsl:template match="ce:keywords">
		<div class="keywords">
			<xsl:choose>
				<xsl:when test="ce:section-title">
					<xsl:apply-templates select="ce:section-title" />
				</xsl:when>
				<xsl:otherwise>
					<h2 id="{@id}">Keywords</h2>
				</xsl:otherwise>
			</xsl:choose>

			<ul class="keyword">
				<xsl:if test="not(ce:section-title)">
					<xsl:attribute name="id">
						<xsl:value-of select="@id" />
					</xsl:attribute>
				</xsl:if>
				<xsl:apply-templates select="ce:keyword" />
			</ul>
		</div>
	</xsl:template>

	<xsl:template match="ce:keywords/ce:section-title">
		<h2 id="{../@id}">
			<xsl:apply-templates />
		</h2>
	</xsl:template>

	<xsl:template match="ce:keywords/ce:keyword">
		<li>
			<xsl:apply-templates />
			<xsl:if test="following-sibling::*">
				<xsl:text>;</xsl:text>
			</xsl:if>
		</li>
	</xsl:template>

	<xsl:template match="ce:keyword/ce:keyword">
		<xsl:text>, </xsl:text>
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="ce:stereochem">
		<dl class="stereochem">
			<xsl:apply-templates select="ce:compound-struct" />
			<xsl:apply-templates select="ce:compound-info" />
			<xsl:apply-templates select="ce:compound-name" />
			<xsl:apply-templates select="ce:compound-formula" />
		</dl>
	</xsl:template>

	<xsl:template match="ce:compound-struct">
		<dt><xsl:apply-templates /></dt>
	</xsl:template>

	<xsl:template match="ce:compound-struct/ce:link">
		<xsl:call-template name="renderBasename">
			<xsl:with-param name="id" select="@locator" />
			<xsl:with-param name="class" select="'compound'" />
			<xsl:with-param name="maxWidth" select="160" />
			<xsl:with-param name="altText" select="'Compound structure'" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="ce:compound-name">
		<dd class="name"><xsl:apply-templates /></dd>
	</xsl:template>

	<xsl:template match="ce:compound-formula"><!-- TODO -->
		<dd class="formula">
			<xsl:apply-templates />
		</dd>
	</xsl:template>

	<xsl:template match="ce:compound-info">
		<dd class="info">
			<dl><xsl:apply-templates /></dl>
		</dd>
	</xsl:template>

	<xsl:template match="ce:compound-info/ce:list-item">
		<dd class="info">
			<xsl:if test="@id">
				<xsl:attribute name="id">
					<xsl:value-of select="@id" />
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</dd>
	</xsl:template>

	<!-- <xsl:template match="ce:nomenclature"><xsl:apply-templates /></xsl:template> -->

	<xsl:template match="ce:nomenclature/ce:section-title">
		<h2>
			<xsl:attribute name="id">
				<xsl:value-of select="../@id" />
			</xsl:attribute>
			<xsl:apply-templates />
		</h2>
	</xsl:template>

	<xsl:template match="ce:salutation">
		<div class="salutation">
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:template match="ce:sections">
		<xsl:choose>
			<xsl:when test="$guest">
				<xsl:apply-templates select=".//ce:display|.//ce:float-anchor" mode="render" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates>
					<xsl:with-param name="level" select="1" />
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<!-- <xsl:template match="ce:appendices"><xsl:apply-templates /></xsl:template> -->

	<xsl:template match="ce:section">
		<xsl:param name="level" />

		<xsl:variable name="title">
			<!-- Apparently there are sections with a label but without a
				 section title, seems to happen mostly with appendixes -->
			<xsl:call-template name="label_and_or_section-title" />
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="2 = $level">
				<h3 id="{@id}">
					<xsl:copy-of select="$title" />
				</h3>
			</xsl:when>
			<xsl:when test="3 = $level">
				<h4 id="{@id}">
					<xsl:copy-of select="$title" />
				</h4>
			</xsl:when>
			<xsl:when test="4 = $level">
				<h5 id="{@id}">
					<xsl:copy-of select="$title" />
				</h5>
			</xsl:when>
			<xsl:when test="5 = $level">
				<h6 id="{@id}">
					<xsl:copy-of select="$title" />
				</h6>
			</xsl:when>
			<xsl:otherwise>
				<h2 id="{@id}">
					<xsl:copy-of select="$title" />
				</h2>
			</xsl:otherwise>
		</xsl:choose>

		<!-- DTD doesn't allow floating anchor in section titles, but
			 apparently it happens. -->
		<xsl:apply-templates select="ce:section-title//ce:float-anchor" mode="render" />

		<xsl:apply-templates select="node()[not(self::ce:label|self::ce:section-title)]">
			<xsl:with-param name="level" select="1 + $level" />
		</xsl:apply-templates>

	</xsl:template>

	<!-- Hanled by inc_para.xsl
		<xsl:template match="ce:para"></xsl:template>
		<xsl:template match="ce:simple-para"></xsl:template>
		<xsl:template match="ce:note-para"></xsl:template>
	-->

	<xsl:template match="ce:intro">
		<h2>Summary</h2>
		<xsl:apply-templates />
		<hr/>
	</xsl:template>

	<xsl:template match="ce:acknowledgment">
		<xsl:if test="not($guest)">
			<xsl:apply-templates />
		</xsl:if>
	</xsl:template>

	<xsl:template match="ce:acknowledgment/ce:section-title">
		<h2 id="{../@id}"><xsl:apply-templates /></h2>
	</xsl:template>

	<xsl:template match="ce:bibliography">
		<xsl:if test="not($guest)">
			<xsl:apply-templates />
		</xsl:if>
	</xsl:template>

	<xsl:template match="ce:bibliography/ce:section-title">
		<h2 id="{../@id}"><xsl:apply-templates /></h2>
	</xsl:template>

	<xsl:template match="ce:bibliography-sec">
		<xsl:apply-templates select="ce:section-title" />

		<ol class="references" style="display:block;"><!--Add display none-->
			<xsl:apply-templates select="ce:bib-reference" />
		</ol>
	</xsl:template>

	<xsl:template match="ce:bibliography-sec/ce:section-title">
		<h3 id="{../@id}"><xsl:apply-templates /></h3>
	</xsl:template>

	<xsl:template match="ce:bib-reference">
		<xsl:apply-templates select="ce:note|sb:reference|ce:other-ref" />
	</xsl:template>

	<xsl:template match="ce:bib-reference/ce:label">
		<a class="label" href="#{../@id}">
			<xsl:apply-templates />
		</a>
	</xsl:template>

	<xsl:template match="ce:bib-reference/ce:note" >
		<li>
			<xsl:if test="not(preceding-sibling::ce:note|preceding-sibling::sb:reference|preceding-sibling::ce:other-ref)">
				<xsl:attribute name="id">
					<xsl:apply-templates select="../@id" />
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="../ce:label" />
			<ol class="reference">
				<li class="source">
					<xsl:apply-templates />
				</li>
			</ol>
		</li>
	</xsl:template>

	<xsl:template match="sb:reference">
		<li>
			<xsl:if test="not(preceding-sibling::ce:note|preceding-sibling::sb:reference|preceding-sibling::ce:other-ref)">
				<xsl:attribute name="id">
					<xsl:apply-templates select="../@id" />
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="not(preceding-sibling::ce:note|preceding-sibling::sb:reference|preceding-sibling::ce:other-ref)">
				<!-- Only show the reference label for the first child. -->
				<xsl:apply-templates select="../ce:label" />
			</xsl:if>
			<xsl:apply-templates select="ce:label" />
			<ol class="reference">
				<xsl:apply-templates select="sb:contribution" />
				<li class="source">
					<!-- Render all sb:host elements including any sb:comment
						 laying before, between or after them. -->
					<xsl:for-each select="sb:host">
						<xsl:choose>
							<xsl:when test="preceding-sibling::*[1][self::sb:comment]">
								<xsl:if test="1 = position()">
									<xsl:text> </xsl:text>
									<xsl:apply-templates select="preceding-sibling::*[1][self::sb:comment]" />
								</xsl:if>
								<!-- Don't use a comma when two sb:host's are
									 separated by a sb:comment -->
								<xsl:text> </xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:if test="1 != position()">
									<xsl:text>, </xsl:text>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>

						<xsl:apply-templates select="." />

						<xsl:if test="following-sibling::*[1][self::sb:comment]">
							<xsl:text> </xsl:text>
							<xsl:apply-templates select="following-sibling::*[1][self::sb:comment]" />
						</xsl:if>
					</xsl:for-each>
				</li>
			</ol>
		</li>
	</xsl:template>

	<xsl:template match="sb:reference/ce:label" >
		<xsl:choose>
			<xsl:when test="../@id">
				<a class="label" href="#{../@id}">
					<xsl:apply-templates />
				</a>
			</xsl:when>
			<xsl:otherwise>
				<span class="label">
					<xsl:apply-templates />
				</span>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="ce:bib-reference/ce:other-ref">
		<li>
			<xsl:if test="not(preceding-sibling::ce:note|preceding-sibling::sb:reference|preceding-sibling::ce:other-ref)">
				<xsl:attribute name="id">
					<xsl:apply-templates select="../@id" />
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="../ce:label" />
			<xsl:apply-templates select="ce:label" />
			<ol class="reference">
				<li class="source">
					<span class="r_other">
						<xsl:apply-templates select="ce:textref" />
					</span>
				</li>
				<li class="external">
				</li>
			</ol>
		</li>
	</xsl:template>

	<xsl:template match="ce:other-ref/ce:label">
		<a class="label" href="#{../@id}">
			<xsl:apply-templates />
		</a>
	</xsl:template>

	<xsl:template match="ja:book-review-head/ce:other-ref">
		<div class="reviewtitle">
			<ol class="reference title">
				<xsl:apply-templates />
			</ol>
		</div>
	</xsl:template>

	<xsl:template match="ce:note">
		<li class="note"><xsl:apply-templates /></li>
	</xsl:template>

	<xsl:template match="ja:book-review-head/sb:reference">
		<div class="reviewtitle">
			<ol class="reference title">
				<xsl:apply-templates />
			</ol>
		</div>
	</xsl:template>

	<xsl:template match="sb:contribution">
		<span class="contribution">
			<xsl:apply-templates select="sb:authors" />
			<xsl:apply-templates select="sb:title|sb:translated-title" />
		</span>
	</xsl:template>

	<xsl:template match="sb:host">
		<xsl:call-template name="seperateByComma" />
	</xsl:template>

	<xsl:template match="sb:comment">
		<span class="r_comment">
			<xsl:if test="preceding-sibling::*">
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:apply-templates />
			<xsl:if test="following-sibling::*">
				<xsl:text> </xsl:text>
			</xsl:if>
		</span>
	</xsl:template>

	<xsl:template match="sb:authors">
		<li class="author">
			<xsl:if test="../preceding-sibling::sb:comment">
				<xsl:apply-templates select="../preceding-sibling::sb:comment" />
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:call-template name="seperateByComma" />
		</li>
	</xsl:template>

	<xsl:template match="sb:collaboration">
		<span class="r_collaboration">
			<xsl:apply-templates />
		</span>
	</xsl:template>

	<xsl:template match="sb:author">
		<span class="r_author">
			<xsl:call-template name="seperateBySpace" />
		</span>
	</xsl:template>

	<xsl:template match="sb:et-al">
		<span class="r_et_al">
			<em>et al.</em>
		</span>
	</xsl:template>

	<xsl:template match="sb:contribution/sb:title">
		<li class="title">
			<span class="r_title">
				<xsl:apply-templates />
			</span>
		</li>
	</xsl:template>

	<xsl:template match="sb:contribution/sb:translated-title">
		<li class="title">
			<span class="r_title">
				<xsl:apply-templates />
			</span>
		</li>
	</xsl:template>

	<xsl:template match="sb:title">
		<span class="r_publication">
			<xsl:apply-templates />
		</span>
	</xsl:template>

	<xsl:template match="sb:translated-title">
		<span class="r_publication_trans">
			<xsl:apply-templates />
		</span>
	</xsl:template>

	<xsl:template match="sb:maintitle">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="sb:subtitle">
		<xsl:text> — </xsl:text>
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="sb:issue">
		<span class="r_issue">
			<xsl:call-template name="seperateByComma" />
		</span>
	</xsl:template>

	<xsl:template match="sb:conference">
		<span class="r_conference">
			<xsl:apply-templates />
		</span>
	</xsl:template>

	<xsl:template match="sb:editors">
		<span class="r_editors">
			<xsl:call-template name="seperateByComma" />
		</span>
	</xsl:template>

	<xsl:template match="sb:editor">
		<span class="r_editor">
			<xsl:call-template name="seperateBySpace" />
		</span>
	</xsl:template>

	<xsl:template match="sb:series">
		<span class="r_series">
			<xsl:call-template name="seperateByComma" />
		</span>
	</xsl:template>

	<xsl:template match="sb:volume-nr">
		<span class="r_volume">
			<xsl:text>Volume </xsl:text>
			<xsl:apply-templates />
		</span>
	</xsl:template>

	<xsl:template match="sb:issue-nr">
		<span class="r_issue">
			<xsl:text>Issue </xsl:text>
			<xsl:apply-templates />
		</span>
	</xsl:template>

	<xsl:template match="sb:date">
		<span class="r_pubdate">
			<xsl:apply-templates />
		</span>
	</xsl:template>

	<xsl:template match="sb:pages">
		<span class="r_pages">
			<!-- Single page: p. / Multiple pages: pp. -->
			<xsl:if test="sb:last-page">p</xsl:if>
			<xsl:text>p. </xsl:text>
			<xsl:apply-templates />
		</span>
	</xsl:template>

	<!-- <xsl:template match="sb:first-page"><xsl:apply-templates /></xsl:template> -->

	<xsl:template match="sb:last-page">
		<xsl:text>–</xsl:text>
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="sb:book">
		<xsl:call-template name="seperateByComma" />
	</xsl:template>

	<!-- <xsl:template match="sb:edition"><xsl:apply-templates /></xsl:template> -->

	<xsl:template match="sb:publisher">
		<span class="r_publisher">
			<xsl:call-template name="seperateByComma" />
		</span>
	</xsl:template>

	<!-- <xsl:template match="sb:name"><xsl:apply-templates /></xsl:template> -->

	<!-- <xsl:template match="sb:location"><xsl:apply-templates /></xsl:template> -->

	<xsl:template match="sb:edited-book">
		<xsl:call-template name="seperateByComma" />
	</xsl:template>

	<xsl:template match="sb:book-series">
		<xsl:call-template name="seperateByComma" />
	</xsl:template>

	<xsl:template match="sb:e-host">
		<span class="r_other">
			<xsl:call-template name="seperateByComma" />
		</span>
	</xsl:template>

	<!-- <xsl:template match="sb:issn"><xsl:apply-templates /></xsl:template> -->

	<xsl:template match="sb:isbn">
		<span class="isbn">
			<xsl:text>ISBN: </xsl:text>
			<xsl:apply-templates />
		</span>
	</xsl:template>

	<!-- <xsl:template match="ce:further-reading"><xsl:apply-templates /></xsl:template> -->

	<xsl:template match="ce:further-reading/ce:section-title">
		<h2 id="{../@id}">
			<xsl:apply-templates />
		</h2>
	</xsl:template>

	<!-- <xsl:template match="ce:further-reading-sec"><xsl:apply-templates /></xsl:template> -->

	<xsl:template match="ce:further-reading-sec">
		<xsl:apply-templates select="ce:section-title" />

		<xsl:if test="ce:bib-reference">
			<ol class="references" style="display:block;"><!--Add display none-->
				<xsl:apply-templates />
			</ol>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ce:further-reading-sec/ce:section-title">
		<h3 id="{../@id}">
			<xsl:apply-templates />
		</h3>
	</xsl:template>

	<!-- <xsl:template match="ce:glossary"><xsl:apply-templates /></xsl:template> -->

	<xsl:template match="ce:glossary/ce:section-title">
		<h2 id="{../@id}">
			<xsl:apply-templates />
		</h2>
	</xsl:template>

	<xsl:template match="ce:glossary-sec">
		<xsl:apply-templates select="ce:section-title|ce:intro" />
		<dl class="glossary">
			<xsl:apply-templates select="ce:glossary-entry" />
		</dl>
	</xsl:template>

	<xsl:template match="ce:glossary-sec/ce:section-title">
		<h3 id="{../@id}">
			<xsl:apply-templates />
		</h3>
	</xsl:template>

	<!-- <xsl:template match="ce:glossary-entry"><xsl:apply-templates /></xsl:template> -->

	<xsl:template match="ce:glossary-heading">
		<dt id="{../@id}">
			<xsl:apply-templates />
		</dt>
	</xsl:template>

	<xsl:template match="ce:glossary-def">
		<dd><xsl:apply-templates /></dd>
	</xsl:template>

	<xsl:template match="ce:index"><!-- TODO -->
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="ce:index/ce:section-title">
		<h2 id="{../@id}">
			<xsl:apply-templates />
		</h2>
	</xsl:template>

	<xsl:template match="ce:index-sec">
		<xsl:apply-templates select="ce:section-title" />
		<ol class="index">
			<xsl:if test="not(ce:label|ce:section-title)">
				<!-- Put identifier on dl if there is no title -->
				<xsl:attribute name="id">
					<xsl:value-of select="@id" />
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="ce:index-entry" />
		</ol>
	</xsl:template>

	<xsl:template match="ce:index-sec/ce:section-title">
		<h3  id="{../@id}">
			<xsl:apply-templates />
		</h3>
	</xsl:template>

	<xsl:template match="ce:index-entry"><!-- TODO -->
		<li>
			<xsl:apply-templates select="ce:index-heading|ce:see|ce:see-also" />
			<div class="refs">
				<xsl:for-each select="ce:cross-ref|ce:intra-ref">
					<xsl:apply-templates select="."/>
				</xsl:for-each>
			</div>
			<xsl:if test="ce:index-entry">
				<ol class="subindex">
					<xsl:apply-templates select="ce:index-entry" />
				</ol>
			</xsl:if>
		</li>
	</xsl:template>

	<xsl:template match="ce:index-heading"><!-- TODO -->
		<strong><xsl:apply-templates /></strong>
	</xsl:template>

	<xsl:template match="ce:see"><!-- TODO -->
		<span class="see">
			<xsl:text>—</xsl:text>
			<xsl:apply-templates />
		</span>
	</xsl:template>

	<xsl:template match="ce:see-also"><!-- TODO -->
		<span class="see-also">
			<xsl:apply-templates />
		</span>
	</xsl:template>

	<xsl:template match="ce:reader-see"><!-- TODO -->
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="ce:index-flag"><!-- TODO -->
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="ce:index-flag-term"><!-- TODO -->
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="ce:index-flag-see"><!-- TODO -->
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="ce:index-flag-see-also"><!-- TODO -->
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="ce:biography">
		<xsl:if test="not($guest)">
			<xsl:if test="not(preceding-sibling::ce:biography)">
				<!-- Only once before all ce:biography -->
				<h2>Vitae</h2>
			</xsl:if>

			<div id="{@id}">
				<xsl:attribute name="class">
					<xsl:choose>
						<xsl:when test="ce:link">biography</xsl:when>
						<xsl:otherwise>vitae</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:apply-templates />
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="ce:biography/ce:link">
		<xsl:call-template name="renderBasename">
			<xsl:with-param name="id" select="@locator" />
			<xsl:with-param name="class" select="'biography'" />
			<xsl:with-param name="forceAttr" select="1" />
			<xsl:with-param name="maxWidth" select="80" />
			<xsl:with-param name="altText" select="'Biography picture'" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="ce:footnote">
		<!-- Don't render footnotes in the normal flow. -->
	</xsl:template>

	<xsl:template match="ce:footnote" mode="render">
		<!-- Especially called from an other template. -->
		<dl id="{@id}" class="footnote">
			<dt class="label">
				<a href="#{@id}">
					<xsl:value-of select="ce:label" />
				</a>
			</dt>
			<dd>
				<xsl:apply-templates select="ce:note-para" />
			</dd>
		</dl>
	</xsl:template>

	<xsl:template match="ce:anchor">
		<!-- TODO: handle the xlink:href attribute -->
		<span id="{@id}">
			<xsl:apply-templates />
		</span>
	</xsl:template>

	<xsl:template match="ce:displayed-quote">
		<blockquote>
			<xsl:if test="@id">
				<xsl:attribute name="id">
					<xsl:value-of select="@id" />
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates/>
		</blockquote>
	</xsl:template>

	<xsl:template match="ce:enunciation">
		<xsl:apply-templates select="ce:para[1]">
			<xsl:with-param name="prepend">
				<strong id="{@id}" class="label">
					<xsl:apply-templates select="ce:label"/>
					<xsl:if test="ce:section-title">
						<xsl:text> (</xsl:text>
						<xsl:apply-templates select="ce:section-title" />
						<xsl:text>)</xsl:text>
					</xsl:if>
				</strong>
				<xsl:text> </xsl:text>
			</xsl:with-param>
		</xsl:apply-templates>
		<xsl:apply-templates select="ce:para[preceding-sibling::ce:para]" />
	</xsl:template>

	<xsl:template match="ce:link">
	</xsl:template>

	<!-- <xsl:template match="ce:include-item"><xsl:apply-templates /></xsl:template> -->

<!-- Pages inside the article XML aren't used, the xocs:* are used.

	<xsl:template match="ce:pages">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="ce:first-page">
		<xsl:apply-templates />
	</xsl:template>

	<xsl:template match="ce:last-page">
		<xsl:apply-templates />
	</xsl:template>
-->

<!-- Handled by inc_cross-refs.xsl
	<xsl:template match="ce:cross-ref"><xsl:apply-templates /></xsl:template>
	<xsl:template match="ce:cross-refs"><xsl:apply-templates /></xsl:template>
	<xsl:template match="ce:intra-ref"><xsl:apply-templates /></xsl:template>
	<xsl:template match="ce:intra-refs"><xsl:apply-templates /></xsl:template>
	<xsl:template match="ce:intra-refs-text"><xsl:apply-templates /></xsl:template>
	<xsl:template match="ce:intra-ref-end"><xsl:apply-templates /></xsl:template>
	<xsl:template match="ce:intra-ref-title"><xsl:apply-templates /></xsl:template>
	<xsl:template match="ce:intra-refs-link"><xsl:apply-templates /></xsl:template>
-->

	<xsl:template match="ce:inter-ref|ce:inter-ref-end">
		<xsl:variable name="href" select="@xlink:href"/>
		<xsl:variable name="cat"  select="substring-before($href,':')"/>
		<xsl:variable name="id"   select="substring-after($href,':')"/>

		<xsl:variable name="ahref">
			<xsl:choose>
				<xsl:when test="$cat='doi'"   >http://dx.doi.org/<xsl:value-of select="$id"/></xsl:when>
				<xsl:when test="$cat='ftp'"   ><xsl:value-of select="$href"/></xsl:when>
				<xsl:when test="$cat='http'"  ><xsl:value-of select="$href"/></xsl:when>
				<xsl:when test="$cat='https'" ><xsl:value-of select="$href"/></xsl:when>
				<xsl:when test="$cat='mailto'"><xsl:value-of select="$href"/></xsl:when>

				<xsl:when test="$cat='arxiv'"    >http://arxiv.org/abs/<xsl:value-of select="$id"/></xsl:when>
				<xsl:when test="$cat='ctgov'"    >http://clinicaltrials.gov/show/<xsl:value-of select="$id"/></xsl:when>
				<xsl:when test="$cat='embl'"     >http://www.ebi.ac.uk/cgi-bin/dbfetch?db=EMBL&amp;id=<xsl:value-of select="$id"/></xsl:when>
				<xsl:when test="$cat='genbank'"  >http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=search&amp;db=nucleotide&amp;doptcmdl=genbank&amp;term=<xsl:value-of select="$id"/>[accn]</xsl:when>
				<xsl:when test="$cat='mi'"       >http://www.ebi.ac.uk/ontology-lookup/?termId=MI:<xsl:value-of select="$id"/></xsl:when>
				<xsl:when test="$cat='mint'"     >http://mint.bio.uniroma2.it/mint/search/interaction.do?interactionAc=<xsl:value-of select="$id"/></xsl:when>
				<xsl:when test="$cat='ncbi-mmdb'">http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=search&amp;db=structure&amp;doptcmdl=genbank&amp;term=<xsl:value-of select="$id"/></xsl:when>
				<xsl:when test="$cat='ncbi-n'"   >http://www.ncbi.nlm.nih.gov/nucest/<xsl:value-of select="$id"/>?report=genbank</xsl:when>
				<xsl:when test="$cat='ncbi-p'"   >http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=search&amp;db=protein&amp;doptcmdl=genbank&amp;term=<xsl:value-of select="$id"/>[accn]</xsl:when>
				<xsl:when test="$cat='ncbi-wgs'" >http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?cmd=search&amp;db=nucleotide&amp;doptcmdl=genbank&amp;term=<xsl:value-of select="$id"/></xsl:when>
				<xsl:when test="$cat='omim'"     >http://www.ncbi.nlm.nih.gov/omim/<xsl:value-of select="$id"/></xsl:when>
				<xsl:when test="$cat='pdb'"      >http://www.rcsb.org/pdb/explore.do?structureId=<xsl:value-of select="$id"/></xsl:when>
				<xsl:when test="$cat='uniprotkb'">http://www.uniprot.org/uniprot/<xsl:value-of select="$id"/></xsl:when>

				<xsl:otherwise>#<!--<xsl:value-of select="$cat"/>_<xsl:value-of select="$id"/>--></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="atitle">
			<xsl:choose>
				<xsl:when test="$cat='doi'"			>DOI: </xsl:when>
				<xsl:when test="$cat='ftp'"			></xsl:when>
				<xsl:when test="$cat='http'"		></xsl:when>
				<xsl:when test="$cat='https'"		></xsl:when>
				<xsl:when test="$cat='mailto'"		>E-mail: </xsl:when>
				<xsl:when test="$cat='arxiv'"		>arXiv: </xsl:when>
				<xsl:when test="$cat='ctgov'"		>ClinicalTrials: </xsl:when>
				<xsl:when test="$cat='embl'"		>EMBL-EBI: </xsl:when>
				<xsl:when test="$cat='genbank'"		>NCBI GenBank: </xsl:when>
				<xsl:when test="$cat='mi'"			>EMBL-EBI Molecular Interaction: </xsl:when>
				<xsl:when test="$cat='mint'"		>HomoMINT interaction: </xsl:when>
				<xsl:when test="$cat='ncbi-mmdb'"	>NCBI Structure: </xsl:when>
				<xsl:when test="$cat='ncbi-n'"		>NCBI Nucleotide: </xsl:when>
				<xsl:when test="$cat='ncbi-p'"		>NCBI Protein: </xsl:when>
				<xsl:when test="$cat='ncbi-wgs'"	>NCBI WGS: </xsl:when>
				<xsl:when test="$cat='omim'"		>NCBI OMIM: </xsl:when>
				<xsl:when test="$cat='pdb'"			>RCSB PDB: </xsl:when>
				<xsl:when test="$cat='uniprotkb'"	>UniProt: </xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="atext">
			<xsl:choose>
				<xsl:when test="text()">
					<xsl:apply-templates />
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$id" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<a class="extern js_extern" href="{$ahref}">
			<xsl:attribute name="title">
				<xsl:value-of select="$atitle" />
				<xsl:value-of select="$atext" />
			</xsl:attribute>
			<xsl:value-of select="$atext" />
		</a>
	</xsl:template>

	<xsl:template match="ce:inter-refs">
		<xsl:for-each select="ce:inter-ref-end">
			<xsl:apply-templates select="."/>
			<xsl:if test="last() &gt; position()">
				<xsl:choose>
					<xsl:when test="last() - 1 = position()"> and </xsl:when>
					<xsl:otherwise>, </xsl:otherwise>
				</xsl:choose>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="ce:inter-refs-text">
		<!-- <xsl:apply-templates /> -->
	</xsl:template>

	<!-- SEE: ce:inter-ref
		<xsl:template match="ce:inter-ref-title"><xsl:apply-templates /></xsl:template>
		<xsl:template match="ce:inter-ref-end"><xsl:apply-templates /></xsl:template>
		<xsl:template match="ce:inter-refs-link"><xsl:apply-templates /></xsl:template>
	-->

	<xsl:template match="ce:list">
		<xsl:if test="ce:label|ce:section-title">
			<h6>
				<xsl:if test="@id">
					<xsl:attribute name="id">
						<xsl:value-of select="@id" />
					</xsl:attribute>
				</xsl:if>
				<xsl:call-template name="label_and_or_section-title" />
			</h6>
		</xsl:if>

		<dl class="listitem">
			<xsl:if test="not(ce:label|ce:section-title)">
				<!-- Put identifier on dl if there is no title -->
				<xsl:if test="@id">
					<xsl:attribute name="id">
						<xsl:value-of select="@id" />
					</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates select="ce:list-item" />
		</dl>
	</xsl:template>

	<xsl:template match="ce:list-item">
		<xsl:apply-templates select="ce:label" />
		<dd>
			<xsl:if test="not(ce:label)">
				<xsl:if test="@id">
					<xsl:attribute name="id">
						<xsl:value-of select="@id" />
					</xsl:attribute>
				</xsl:if>
			</xsl:if>
			<xsl:apply-templates select="ce:para" />
		</dd>
	</xsl:template>

	<xsl:template match="ce:list-item/ce:label">
		<dt class="label">
			<xsl:if test="../@id">
				<xsl:attribute name="id">
					<xsl:value-of select="../@id" />
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</dt>
	</xsl:template>

	<xsl:template match="ce:def-list">
		<xsl:if test="ce:label|ce:section-title">
			<h6 id="{@id}">
				<xsl:call-template name="label_and_or_section-title" />
			</h6>
		</xsl:if>

		<dl class="deflist">
			<xsl:if test="not(ce:label|ce:section-title)">
				<!-- Put identifier on dl if there is no title -->
				<xsl:attribute name="id">
					<xsl:value-of select="@id" />
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates select="ce:def-term|ce:def-description" />
			<dd class="clear"></dd>
		</dl>
	</xsl:template>

	<xsl:template match="ce:def-term">
		<dt>
			<xsl:if test="@id">
				<xsl:attribute name="id">
					<xsl:value-of select="@id" />
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates />
		</dt>
	</xsl:template>

	<xsl:template match="ce:def-description">
		<dd><xsl:apply-templates /></dd>
	</xsl:template>

	<!-- <xsl:template match="ce:inline-figure"><xsl:apply-templates /></xsl:template> -->

	<xsl:template match="ce:inline-figure/ce:link">
		<xsl:call-template name="renderBasename">
			<xsl:with-param name="id" select="@locator" />
			<xsl:with-param name="scrollWidth" select="800" />
			<xsl:with-param name="altText" select="'Inline figure'" />
		</xsl:call-template>
	</xsl:template>

	<!-- <xsl:template match="ce:chem"><xsl:apply-templates /></xsl:template> -->

	<xsl:template match="ce:floats">
		<!-- Don't render the floats inside the normal flow -->
	</xsl:template>

	<xsl:template match="ce:float-anchor">
		<!-- Don't render the float anchors inside the normal flow, they are
			 rendered after the paragraph is finished. -->
	</xsl:template>

	<!-- <xsl:template match="ce:display"><xsl:apply-templates /></xsl:template> -->
	<xsl:template match="ce:display" mode="render"><xsl:apply-templates /></xsl:template>

	<xsl:template match="ce:caption">
		<xsl:param name="label" />

		<xsl:choose>
			<xsl:when test="'' != $label">
				<xsl:apply-templates select="ce:simple-para[1]">
					<xsl:with-param name="prepend">
						<span class="label">
							<xsl:apply-templates select="$label"/>
							<xsl:text>.</xsl:text>
						</span>
						<xsl:text> </xsl:text>
					</xsl:with-param>
				</xsl:apply-templates>
				<xsl:apply-templates select="ce:simple-para[preceding-sibling::ce:simple-para]" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="ce:simple-para" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="ce:source">
		<div class="source"><xsl:apply-templates /></div>
	</xsl:template>

	<xsl:template match="ce:formula">
		<div id="{@id}" class="formula">
			<xsl:apply-templates />
		</div>
	</xsl:template>

	<xsl:template match="ce:formula/ce:label">
		<xsl:variable name="label"><xsl:apply-templates /></xsl:variable>
		<xsl:choose>
			<xsl:when test="starts-with($label, '(')">
				<div class="label">
					<span class="offscreen">equation</span>
					<span class="parentheses"><xsl:value-of select="translate($label, '()', '')" /></span>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div class="label">
					<span class="offScreen">equation</span>
					<xsl:apply-templates />
				</div>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template match="ce:figure">
		<div class="float figure" id="{@id}">
			<xsl:for-each select="ce:figure">
				<xsl:apply-templates select="." />
			</xsl:for-each>

			<xsl:apply-templates select="ce:link" />

			<xsl:if test="ce:caption|ce:label">
				<div class="caption">
					<xsl:choose>
						<xsl:when test="ce:caption">
							<xsl:apply-templates select="ce:caption">
								<xsl:with-param name="label" select="ce:label" />
							</xsl:apply-templates>
						</xsl:when>
						<xsl:when test="ce:label">
							<xsl:apply-templates select="ce:label" />
						</xsl:when>
					</xsl:choose>
				</div>
			</xsl:if>

			<xsl:apply-templates select="ce:source|ce:copyright" />
		</div>
	</xsl:template>

	<xsl:template match="ce:figure/ce:link">
		<xsl:variable name="altText">
			<xsl:choose>
				<xsl:when test="../ce:label"><xsl:value-of select="../ce:label" /></xsl:when>
				<xsl:otherwise>Figure</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<div class="data">
			<xsl:choose>
				<xsl:when test="$guest">
					<xsl:call-template name="renderBasename">
						<xsl:with-param name="type" select="'IMAGE-THUMBNAIL'" />
						<xsl:with-param name="id" select="@locator" />
						<xsl:with-param name="maxWidth" select="100" />
						<xsl:with-param name="altText" select="$altText" />
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="renderBasename">
						<xsl:with-param name="id" select="@locator" />
						<xsl:with-param name="scrollWidth" select="800" />
						<xsl:with-param name="altText" select="$altText" />
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="ce:textbox">
		<xsl:choose>
			<xsl:when test="$guest">
				<xsl:apply-templates select=".//ce:display|.//ce:float-anchor" mode="render" />
			</xsl:when>
			<xsl:otherwise>
				<!-- TODO: It looks good, but I didn't checked all possibilities since
					 there are a lot of them. A textbox could in theory contain a
					 complete article. -->
				<div id="{@id}" class="textbox {@role}">
					<xsl:choose>
						<xsl:when test="ce:caption">
							<xsl:apply-templates select="ce:caption">
								<xsl:with-param name="label" select="ce:label" />
							</xsl:apply-templates>
						</xsl:when>
						<xsl:when test="ce:label">
							<p class="caption">
								<xsl:apply-templates select="ce:label" />
							</p>
						</xsl:when>
					</xsl:choose>

					<xsl:apply-templates select="ce:source|ce:copyright" />
					<xsl:apply-templates select="ce:textbox-head|ce:textbox-body|ce:textbox-tail" />
				</div>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	<!-- <xsl:template match="ce:textbox-head"><xsl:apply-templates /></xsl:template> -->
	<!-- <xsl:template match="ce:textbox-body"><xsl:apply-templates /></xsl:template> -->
	<!-- <xsl:template match="ce:textbox-tail"><xsl:apply-templates /></xsl:template> -->

	<xsl:template match="ce:e-component">
		<!-- Looks very much like a figure, but the main difference is the link
			 could be anything from spreadsheets, documents, images, audio,
			 video. -->
		<dl id="{@id}" class="float ecomponent">
			<xsl:apply-templates select="ce:link" />
			<xsl:choose>
				<xsl:when test="ce:caption|ce:label">
					<dd>
						<xsl:choose>
							<xsl:when test="ce:caption">
								<xsl:apply-templates select="ce:caption">
									<xsl:with-param name="label" select="ce:label" />
								</xsl:apply-templates>
							</xsl:when>
							<xsl:when test="ce:label">
								<xsl:apply-templates select="ce:label" />
							</xsl:when>
						</xsl:choose>
					</dd>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="ce:alt-e-component" />
				</xsl:otherwise>
			</xsl:choose>

			<xsl:apply-templates select="ce:source" />
			<xsl:apply-templates select="ce:copyright" />

			<xsl:apply-templates select="ce:e-component" />

			<xsl:variable name="locator" select="ce:link/@locator" />
		</dl>
	</xsl:template>

	<!--
		<xsl:template match="ce:e-component/ce:label"><xsl:apply-templates /></xsl:template>
		<xsl:template match="ce:e-component/ce:caption"><xsl:apply-templates /></xsl:template>
	-->

	<xsl:template match="ce:e-component/ce:copyright">
		<dd><xsl:apply-templates /></dd>
	</xsl:template>

	<xsl:template match="ce:e-component/ce:alt-e-component">
		<xsl:apply-templates select="ce:caption" />
	</xsl:template>

	<xsl:template match="ce:e-component/ce:alt-e-component/ce:caption">
		<dd><xsl:apply-templates /></dd>
	</xsl:template>

	<xsl:template match="ce:e-component/ce:link">
		<xsl:variable name="locator" select="@locator" />

		<!-- Check content-type and render component accordingly. -->
		<xsl:choose>

<!-- GUEST USER Always icon -->
			<xsl:when test="$guest">
				<dt>
					<xsl:choose>
						<xsl:when test="key('type-name-id', concat('VIDEO', $locator))">
							<span class="mmc mp4"><xsl:comment/></span>
						</xsl:when>
						<xsl:when test="key('type-name-id', concat('VIDEO-FLASH', $locator))">
							<span class="mmc mp4"><xsl:comment/></span>
						</xsl:when>
						<xsl:when test="key('type-name-id', concat('IMAGE-DOWNSAMPLED', $locator))">
							<span class="mmc jpg"><xsl:comment/></span>
						</xsl:when>
						<xsl:when test="key('type-name-id', concat('AUDIO', $locator))">
							<span class="mmc mp3"><xsl:comment/></span>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="key('basename-id', $locator)[1]">
								<span class="mmc {xocs:extension}"><xsl:comment/></span>
								<xsl:value-of select="xocs:filename" />
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</dt>
			</xsl:when>

<!-- VIDEO (Flash) -->
			<xsl:when test="key('type-name-id', concat('VIDEO-FLASH', $locator))">
				<xsl:variable name="video" select="key('type-name-id', concat('VIDEO-FLASH', $locator))" />
				<xsl:variable name="thumb" select="key('type-name-id', concat('IMAGE-MMC-THUMBNAIL', $locator))" />
				<xsl:variable name="altimg" select="key('type-name-id', concat('IMAGE-DOWNSAMPLED', ../ce:alt-e-component/ce:link/@locator))" />


				<xsl:variable name="width">
					<xsl:choose>
						<xsl:when test="300 &gt; $video/xocs:pixel-width">
							<xsl:value-of select="400" />
						</xsl:when>
						<xsl:when test="600 &lt; $video/xocs:pixel-width">
							<xsl:value-of select="600" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$video/xocs:pixel-width" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="height">
					<xsl:choose>
						<xsl:when test="300 &gt; $video/xocs:pixel-width">
							<xsl:value-of select="floor($video/xocs:pixel-height * 400 div $video/xocs:pixel-width)" />
						</xsl:when>
						<xsl:when test="600 &lt; $video/xocs:pixel-width">
							<xsl:value-of select="floor($video/xocs:pixel-height * 600 div $video/xocs:pixel-width)" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$video/xocs:pixel-height" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<dd class="video">
					<a id="videoplayer_{$locator}" class="js_video">
						<xsl:attribute name="href">
							<xsl:value-of select="$base_url" />
							<xsl:text>attachment/stream/</xsl:text>
							<xsl:value-of select="$video/xocs:attachment-eid" />
						</xsl:attribute>
						<img alt="Video frame" height="{$height}" width="{$width}">
							<xsl:attribute name="src">
								<xsl:choose>
									<xsl:when test="$altimg">
										<xsl:value-of select="$image_url" />
										<xsl:value-of select="$altimg/xocs:attachment-eid" />
										<xsl:text>?w=</xsl:text>
										<xsl:value-of select="$altimg/xocs:pixel-width" />
										<xsl:text>&amp;h=</xsl:text>
										<xsl:value-of select="$altimg/xocs:pixel-height" />
									</xsl:when>
									<xsl:when test="$thumb">
										<xsl:value-of select="$image_url" />
										<xsl:value-of select="$thumb/xocs:attachment-eid" />
										<xsl:text>?w=</xsl:text>
										<xsl:value-of select="$thumb/xocs:pixel-width" />
										<xsl:text>&amp;h=</xsl:text>
										<xsl:value-of select="$thumb/xocs:pixel-height" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$base_url" />
										<xsl:text>images/video_default.png</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
						</img>
						<span class="playicon"><xsl:comment/></span>
					</a>
				</dd>
			</xsl:when>
<!-- VIDEO (Mpeg) -->
			<xsl:when test="key('type-name-id', concat('VIDEO', $locator))">
				<xsl:variable name="video" select="key('type-name-id', concat('VIDEO', $locator))" />
				<xsl:variable name="thumb" select="key('type-name-id', concat('IMAGE-MMC-THUMBNAIL', $locator))" />

				<dd class="video">
					<a id="videoplayer_{$locator}" class="js_video">
						<xsl:attribute name="href">
							<xsl:value-of select="$base_url" />
							<xsl:text>attachment/stream/</xsl:text>
							<xsl:value-of select="$video/xocs:attachment-eid" />
						</xsl:attribute>
						<xsl:if test="$thumb">
							<img alt="Video frame" height="{$thumb/xocs:pixel-height * 2}" width="{$thumb/xocs:pixel-width * 2}">
								<xsl:attribute name="src">
									<xsl:value-of select="$image_url" />
									<xsl:value-of select="$thumb/xocs:attachment-eid" />
									<xsl:text>?w=</xsl:text>
									<xsl:value-of select="$thumb/xocs:pixel-width" />
									<xsl:text>&amp;h=</xsl:text>
									<xsl:value-of select="$thumb/xocs:pixel-height" />
								</xsl:attribute>
							</img>
						</xsl:if>
						<span class="playicon"><xsl:comment/></span>
					</a>
				</dd>
			</xsl:when>
<!-- IMAGE -->
			<xsl:when test="key('type-name-id', concat('IMAGE-DOWNSAMPLED', $locator))">
				<dt><span class="mmc jpg"><xsl:comment/></span></dt>
				<xsl:variable name="altText">
					<xsl:choose>
						<xsl:when test="../ce:label"><xsl:value-of select="../ce:label" /></xsl:when>
						<xsl:otherwise>Figure</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
			</xsl:when>
<!-- AUDIO -->
			<xsl:when test="key('type-name-id', concat('AUDIO', $locator))">
				<xsl:variable name="audio" select="key('type-name-id', concat('AUDIO', $locator))" />

				<dd class="audio">
					<a id="audioplayer_{$locator}" class="js_audio">
						<xsl:attribute name="href">
							<xsl:value-of select="$base_url" />
							<xsl:text>attachment/stream/</xsl:text>
							<xsl:value-of select="$audio/xocs:attachment-eid" />
						</xsl:attribute>
						Listen to audio fragment
						<span class="playicon"><xsl:comment/></span>
					</a>
				</dd>
			</xsl:when>
<!-- OTHER (DOC,XLS,PDF,etc) -->
			<xsl:otherwise>
				<xsl:for-each select="key('basename-id', $locator)[1]">
					<dt>
						<span class="mmc {xocs:extension}"><xsl:comment/></span>
						<xsl:value-of select="xocs:filename" />
					</dt>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="ce:e-component/ce:e-component">
		<dd>
			<dl class="ecomponent">
				<xsl:apply-templates />
			</dl>
		</dd>
	</xsl:template>

	<!-- <xsl:template match="ce:alt-e-component"><xsl:apply-templates /></xsl:template> -->

	<xsl:template match="ce:bold">
		<strong><xsl:apply-templates /></strong>
	</xsl:template>

	<xsl:template match="ce:italic">
		<em><xsl:apply-templates /></em>
	</xsl:template>

	<xsl:template match="ce:sans-serif">
		<span class="sans-serif"><xsl:apply-templates /></span>
	</xsl:template>

	<xsl:template match="ce:monospace">
		<span class="monospace"><xsl:apply-templates /></span>
	</xsl:template>

	<xsl:template match="ce:small-caps">
		<span class="small-caps"><xsl:apply-templates /> </span>
	</xsl:template>

	<xsl:template match="ce:underline">
		<span class="underline"><xsl:apply-templates /></span>
	</xsl:template>

	<xsl:template match="ce:cross-out">
		<span class="cross-out"><xsl:apply-templates /></span>
	</xsl:template>

	<xsl:template match="ce:sup">
		<sup><xsl:apply-templates /></sup>
	</xsl:template>

	<xsl:template match="ce:inf">
		<sub><xsl:apply-templates /></sub>
	</xsl:template>

	<xsl:template match="ce:hsp">
		<!-- Horizontal space -->
		<xsl:text> </xsl:text>
	</xsl:template>

	<xsl:template match="ce:vsp">
		<!-- Vertical space -->
	</xsl:template>

	<xsl:template match="ce:br">
		<!-- Line break -->
		<br/>
	</xsl:template>

	<xsl:template match="ce:glyph">
		<img class="glyph" src="{$glyph_url}{@name}.gif">
			<xsl:attribute name="alt">
				<xsl:choose>
					<xsl:when test="@name = 'bigdot'">big dot above</xsl:when>
					<xsl:when test="@name = 'btmlig'">bottom ligature</xsl:when>
					<xsl:when test="@name = 'camb'">Cambrian</xsl:when>
					<xsl:when test="@name = 'ctl'">curly tail</xsl:when>
					<xsl:when test="@name = 'dbnd'">double bond; length as m-dash</xsl:when>
					<xsl:when test="@name = 'dbnd6'">6-point double bond; length half of m-dash</xsl:when>
					<xsl:when test="@name = 'dcurt'">curly-tail d</xsl:when>
					<xsl:when test="@name = 'dlcorn'">left bottom corner, long</xsl:when>
					<xsl:when test="@name = 'drcorn'">right bottom corner, long</xsl:when>
					<xsl:when test="@name = 'ggrave'">extra low, accent</xsl:when>
					<xsl:when test="@name = 'hbar'">horizontal bar</xsl:when>
					<xsl:when test="@name = 'heng'">heng</xsl:when>
					<xsl:when test="@name = 'herma'">hermaphrodite</xsl:when>
					<xsl:when test="@name = 'hris'">high rising, accent</xsl:when>
					<xsl:when test="@name = 'hriss'">high rising, symbol</xsl:when>
					<xsl:when test="@name = 'hrttrh'">turned h, hook right tail</xsl:when>
					<xsl:when test="@name = 'ht'">hooktop</xsl:when>
					<xsl:when test="@name = 'jnodot'">j, undotted</xsl:when>
					<xsl:when test="@name = 'lbd2bd'">2 bonds on the lefthand side, bottom double</xsl:when>
					<xsl:when test="@name = 'lbd2td'">2 bonds on the lefthand side, top double</xsl:when>
					<xsl:when test="@name = 'lbond2'">2 bonds on the lefthand side</xsl:when>
					<xsl:when test="@name = 'lbond3'">3 bonds on the lefthand side</xsl:when>
					<xsl:when test="@name = 'lozf'">lozenge, filled</xsl:when>
					<xsl:when test="@name = 'lozfl'">lozenge, left filled</xsl:when>
					<xsl:when test="@name = 'lozfr'">lozenge, right filled</xsl:when>
					<xsl:when test="@name = 'lris'">low rising, accent</xsl:when>
					<xsl:when test="@name = 'lriss'">low rising, symbol</xsl:when>
					<xsl:when test="@name = 'ncurt'">curly-tail n</xsl:when>
					<xsl:when test="@name = 'nsmid'">nshortmid</xsl:when>
					<xsl:when test="@name = 'nspar'">not short parallel</xsl:when>
					<xsl:when test="@name = 'pdbdtd'">partial double bond, top dashed</xsl:when>
					<xsl:when test="@name = 'pdbond'">Partial double bond</xsl:when>
					<xsl:when test="@name = 'pent'">pentagon</xsl:when>
					<xsl:when test="@name = 'phktp'">p hooktop</xsl:when>
					<xsl:when test="@name = 'pSlash'">double Slash</xsl:when>
					<xsl:when test="@name = 'ptbdbd'">partial triple bond, bottom dashed</xsl:when>
					<xsl:when test="@name = 'ptbdtd'">partial triple bond, top dashed</xsl:when>
					<xsl:when test="@name = 'qbnd'">quadruple bond; length as m-dash</xsl:when>
					<xsl:when test="@name = 'qbnd6'">six-point quadruple bond; length half of m-dash</xsl:when>
					<xsl:when test="@name = 'rad'">radical dot</xsl:when>
					<xsl:when test="@name = 'rbd2bd'">2 bonds on the righthand side, bottom double</xsl:when>
					<xsl:when test="@name = 'rbd2td'">2 bonds on the righthand side, top double</xsl:when>
					<xsl:when test="@name = 'rbond2'">2 bonds on the righthand side</xsl:when>
					<xsl:when test="@name = 'rbond3'">3 bonds on the righthand side</xsl:when>
					<xsl:when test="@name = 'refhrl'">reversed fish-hook r, long leg</xsl:when>
					<xsl:when test="@name = 'resmck'">small capital K, reversed</xsl:when>
					<xsl:when test="@name = 'risfla'">rising-falling, accent</xsl:when>
					<xsl:when test="@name = 'risfls'">rising-falling, symbol</xsl:when>
					<xsl:when test="@name = 'S'">S-sign</xsl:when>
					<xsl:when test="@name = 'sbnd'">single bond</xsl:when>
					<xsl:when test="@name = 'sbw'">subscript w</xsl:when>
					<xsl:when test="@name = 'smid'">shortmid</xsl:when>
					<xsl:when test="@name = 'spar'">short parallel</xsl:when>
					<xsl:when test="@name = 'sqfb'">square, bottom filled</xsl:when>
					<xsl:when test="@name = 'sqfne'">square with filled N-E-corner</xsl:when>
					<xsl:when test="@name = 'sqfsw'">square with filled S-W-corner</xsl:when>
					<xsl:when test="@name = 'sqft'">square, top filled</xsl:when>
					<xsl:when test="@name = 'tbnd'">triple bond; length as m-dash</xsl:when>
					<xsl:when test="@name = 'tbnd6'">6-point triple bond; length half of m-dash</xsl:when>
					<xsl:when test="@name = 'tcurt'">curly-tail t</xsl:when>
					<xsl:when test="@name = 'trisla'">triple Slash</xsl:when>
					<xsl:when test="@name = 'trnomeg'">inverted omega</xsl:when>
				</xsl:choose>
			</xsl:attribute>
		</img>
	</xsl:template>

	<xsl:template match="ce:grant-sponsor"><!-- TODO -->
		<span id="{@id}"><xsl:apply-templates /></span>
	</xsl:template>

	<xsl:template match="ce:grant-number"><!-- TODO -->
		<a href="#{@refid}"><xsl:apply-templates /></a>
	</xsl:template>

	<xsl:template match="ce:exam-reference">
		<xsl:if test="not($guest)">
			<xsl:apply-templates />
		</xsl:if>
	</xsl:template>

	<xsl:template match="ce:exam-questions">
		<xsl:if test="not($guest)">
			<xsl:apply-templates />
		</xsl:if>
	</xsl:template>

	<xsl:template match="ce:exam-questions/ce:section-title">
		<h2 id="{../@id}"><xsl:apply-templates /></h2>
	</xsl:template>

	<xsl:template match="ce:exam-answers">
		<xsl:if test="not($guest)">
			<xsl:apply-templates />
		</xsl:if>
	</xsl:template>

	<xsl:template match="ce:exam-answers/ce:section-title">
		<h2 id="{../@id}"><xsl:apply-templates /></h2>
	</xsl:template>

	<xsl:template match="ce:legend">
		<div class="legend"><xsl:apply-templates /></div>
	</xsl:template>

	<xsl:template match="ce:table">
		<div id="{@id}" class="float table">
			<div class="caption">
				<xsl:choose>
					<xsl:when test="ce:caption">
						<xsl:apply-templates select="ce:caption">
							<xsl:with-param name="label" select="ce:label" />
						</xsl:apply-templates>
					</xsl:when>
					<xsl:when test="ce:label">
						<xsl:apply-templates select="ce:label" />
					</xsl:when>
				</xsl:choose>
			</div>

			<!-- table -->
			<div class="data">
				<xsl:choose>
					<xsl:when test="$guest">
						<span class="icon table">&#160;</span>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="cals:tgroup">
							<xsl:apply-templates select=".">
								<xsl:with-param name="sumamry" select="../ce:label" />
							</xsl:apply-templates>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>

				<!-- table (img) -->
				<xsl:apply-templates select="ce:link" />
			</div>

			<xsl:apply-templates select="ce:legend" />

			<xsl:if test="ce:table-footnote">
				<dl class="footnotes">
					<xsl:apply-templates select="ce:table-footnote" />
				</dl>
			</xsl:if>

			<xsl:apply-templates select="ce:source|ce:copyright" />

		</div>
	</xsl:template>

	<xsl:template match="ce:table/ce:link">
		<xsl:variable name="altText">
			<xsl:choose>
				<xsl:when test="../ce:label"><xsl:value-of select="../ce:label" /></xsl:when>
				<xsl:otherwise>Table</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:call-template name="renderBasename">
			<xsl:with-param name="id" select="@locator" />
			<xsl:with-param name="class" select="'table'" />
			<xsl:with-param name="scrollWidth" select="800" />
			<xsl:with-param name="altText" select="$altText" />
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="ce:table-footnote">
		<dt id="{@id}">
			<a href="#{@id}">
				<xsl:value-of select="ce:label" />
			</a>
		</dt>
		<dd>
			<xsl:apply-templates select="ce:note-para"/>
		</dd>
	</xsl:template>

	<xsl:template match="cals:tgroup">
		<table>
			<xsl:for-each select="cals:colspec">
				<col/>
			</xsl:for-each>
			<xsl:for-each select="cals:thead">
				<thead>
					<xsl:for-each select="cals:row">
						<xsl:variable name="parentPosition" select="position()" />
						<xsl:variable name="parentLast" select="last()" />
						<tr>
							<xsl:for-each select="ce:entry">
								<xsl:variable name="colstart"><xsl:value-of select="substring(@namest,4,99)" /></xsl:variable>
								<xsl:variable name="colend"><xsl:value-of select="substring(@nameend,4,99)" /></xsl:variable>
								<th>
									<xsl:if test="'' != $colstart">
										<xsl:attribute name="colspan"><xsl:value-of select="1+number($colend)-number($colstart)" /></xsl:attribute>
									</xsl:if>
									<xsl:if test="'' != @morerows">
										<xsl:attribute name="rowspan"><xsl:value-of select="1+number(@morerows)" /></xsl:attribute>
									</xsl:if>

									<xsl:apply-templates/>
									<xsl:if test="'' != $colstart and $parentLast != $parentPosition">
										<hr />
									</xsl:if>

								</th>
							</xsl:for-each>
						</tr>
					</xsl:for-each>
				</thead>
			</xsl:for-each>
			<xsl:for-each select="cals:tbody">
				<tbody>
					<xsl:for-each select="cals:row">
						<xsl:variable name="parentPosition" select="position()" />
						<xsl:variable name="parentLast" select="last()" />

						<xsl:choose>
							<xsl:when test="ce:entry/ce:vsp and 1 = count(ce:entry)">
								<tr class="spacer">
									<td>
										<xsl:variable name="colstart"><xsl:value-of select="substring(ce:entry/@namest,4,99)" /></xsl:variable>
										<xsl:variable name="colend"><xsl:value-of select="substring(ce:entry/@nameend,4,99)" /></xsl:variable>
										<xsl:if test="'' != $colstart">
											<xsl:attribute name="colspan"><xsl:value-of select="1+number($colend)-number($colstart)" /></xsl:attribute>
										</xsl:if>
										<xsl:text> </xsl:text>
									</td>
								</tr>
							</xsl:when>
							<xsl:otherwise>
								<tr>
									<xsl:for-each select="ce:entry">
										<xsl:variable name="colstart"><xsl:value-of select="substring(@namest,4,99)" /></xsl:variable>
										<xsl:variable name="colend"><xsl:value-of select="substring(@nameend,4,99)" /></xsl:variable>
										<td>
											<xsl:if test="'' != $colstart">
												<xsl:attribute name="colspan"><xsl:value-of select="1+number($colend)-number($colstart)" /></xsl:attribute>
											</xsl:if>
											<xsl:if test="'' != @morerows">
												<xsl:attribute name="rowspan"><xsl:value-of select="1+number(@morerows)" /></xsl:attribute>
											</xsl:if>
											<xsl:variable name="tdContent"><xsl:apply-templates/></xsl:variable>
											<xsl:choose>
												<xsl:when test="'' = $tdContent">
													<xsl:text> </xsl:text>
												</xsl:when>
												<xsl:otherwise>
													<xsl:copy-of select="$tdContent" />
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</xsl:for-each>
								</tr>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>
				</tbody>
			</xsl:for-each>
		</table>
	</xsl:template>

	<!-- <xsl:template match="tb:top-border"><xsl:apply-templates /></xsl:template> -->
	<!-- <xsl:template match="tb:left-border"><xsl:apply-templates /></xsl:template> -->
	<!-- <xsl:template match="tb:bottom-border"><xsl:apply-templates /></xsl:template> -->
	<!-- <xsl:template match="tb:right-border"><xsl:apply-templates /></xsl:template> -->
	<!-- <xsl:template match="tb:alignmark"><xsl:apply-templates /></xsl:template> -->
	<!-- <xsl:template match="tb:colspec"><xsl:apply-templates /></xsl:template> -->

	<xsl:template match="mml:math[@altimg]">
		<xsl:text> </xsl:text>
		<xsl:call-template name="renderFormula">
			<xsl:with-param name="id" select="@altimg" />
			<xsl:with-param name="maxWidth" select="560" />
			<xsl:with-param name="altText" select="'mathformula'" />
		</xsl:call-template>
	</xsl:template>


	<!-- - - - - - - - -->
	<!-- HACK / QUIRKS -->
	<!-- - - - - - - - -->

	<xsl:template match="*[@altimg]">
		<xsl:text> </xsl:text>
		<xsl:call-template name="renderFormula">
			<xsl:with-param name="id" select="@altimg" />
			<xsl:with-param name="maxWidth" select="560" />
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>

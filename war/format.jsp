<%@page import="wiki.Format,
                wiki.Properties,
                wiki.Util,
                wiki.XmlSerializer"%>
<%
  final String formatName = (String) request.getAttribute("formatName");
  final Format format = (Format) request.getAttribute("format");
  final boolean startEdit = format.getFields().isEmpty();
  final String hostURL = Util.getHostURL(request);
  final String self = hostURL + request.getRequestURI();
  final String safeName = Util.encodeForHTML(format.getName());
  final boolean online = Properties.getBoolean("online");
%>
<html>
  <head>
    <jsp:include page="header.jsp"/>
    <script src="/Format.js" type="text/javascript"></script>
    <script src="/FormEditor.js" type="text/javascript"></script>
    <script src="/FormConverter.js" type="text/javascript"></script>
    <script src="/FieldEditor.js" type="text/javascript"></script>
    <link rel="stylesheet" href="/format.css" type="text/css"/>
  </head>
  <body onload="Format(<%= startEdit %>);">
    <jsp:include page="onebar.jsp"/>
    <jsp:include page="nav.jsp"/>
    <div class="mainPanel">
      <ul class="tabs">
        <li><a href="/wiki/<%= safeName %>">Dataset</a></li>
        <li class="activeTab">Format</li>
        <jsp:include page="search.jsp"/>
      </ul>
      <div id="formatBox" class="box">
        <div id="formatPanelLeft">
          <jsp:include page="formatSummary.jsp"/>
        </div>
        <div id="formatPanelRight">
          <ul id="formTabs" class="tabs">
            <li class="activeTab"><a>Sample form</a></li>
          </ul>
          <div id="tabbedForms">
            <jsp:include page="form.jsp">
              <jsp:param name="jspFormId" value="formEdit"/>
              <jsp:param name="jspFormTitle" value="Edit"/>
              <jsp:param name="jspFormMethod" value="GET"/>
              <jsp:param name="jspFormAction" value="<%= \"/wiki/\"+ safeName %>"/>
            </jsp:include>
          </div>
        </div>
        <div>
          <h3>Developer Guide</h3>
          <h4>Web API</h4>
          <p>This dataset can be searched or retrieved in bulk using
          a <a href="http://en.wikipedia.org/wiki/Representational_State_Transfer">RESTful</a>
            <a href="http://en.wikipedia.org/wiki/Web_service">Web
          Service</a> <a href="http://en.wikipedia.org/wiki/Application_programming_interface">API</a>.</p>

          <p>All documents may be retrieved in Atom format using this URL:</p>
          <pre><%= hostURL %>/wiki/<%= safeName %>?output=xml</pre>

          <p>A search for documents matching some criteria may be
          specified by setting the <code>q</code> request parameter
          and one or more <code>&amp;FIELD=VALUE</code>
          attribute/value pairs to return documents which have all of
          the requested attributes.  The FIELD name must match exactly
          the value of the name attribute used in the HTML form input
          for the associated field, as desribed in the "HTML Find and
          Create Forms" section below.</p>
          <pre><%= hostURL %>/wiki/<%= safeName %>?q&amp;output=xml&amp;example=value</pre>

          <h4>XML Template</h4>
          <p>Documents retrieved in XML format will have the following
          structure.</p>

<%
 String formatXmlStr = "";
 try {
   formatXmlStr = XmlSerializer.toXml(format);
 } catch (Exception e) {
%>
 <!-- format: <%= format %> -->
<%
 }
%>
          <pre><%= Util.encodeForHTML(formatXmlStr) %></pre>

          <h4>HTML Find and Create Forms</h4>
          <p>You can use forms for finding or creating documents in
          this dataset on your own site using the following HTML code.
          Embedding this code on your site will present a plain form
          that will submit a request directly from the user's web
          browser to this site.</p>

          <p>Find:</p>
<pre><%= XmlSerializer.toFindForm(format, hostURL, format.getFields()).replaceAll("<", "&lt;").replaceAll(">", "&gt;") %></pre>
          <p>Create:</p>
<pre><%= XmlSerializer.toCreateForm(format, hostURL, format.getFields()).replaceAll("<", "&lt;").replaceAll(">", "&gt;") %></pre>
        </div>
      </div>
      <jsp:include page="form-template.jsp"/><!-- Has to be outside of formatBox to hide input elts from FormEditor.js. -->
    </div>
  </body>
</html>
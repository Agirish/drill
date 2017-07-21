<#--

    Licensed to the Apache Software Foundation (ASF) under one
    or more contributor license agreements.  See the NOTICE file
    distributed with this work for additional information
    regarding copyright ownership.  The ASF licenses this file
    to you under the Apache License, Version 2.0 (the
    "License"); you may not use this file except in compliance
    with the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

-->
<#include "*/generic.ftl">
<#macro page_head>
</#macro>

<#macro page_body>
  <a href="/queries">back</a><br/>
  <div class="page-header">
  </div>
  <h4>Enabled Storage Plugins</h4>
  <div class="table-responsive">
    <table class="table">
      <tbody>
        <#list model as plugin>
          <#if plugin.enabled() == true>
            <tr>
              <td style="border:none; width:200px;">
                ${plugin.getName()}
              </td>
              <td style="border:none;">
                <a class="btn btn-primary" href="/storage/${plugin.getName()}">Update</a>
                <a class="btn btn-default" onclick="doEnable('${plugin.getName()}', false)">Disable</a>
                <a class="btn btn-default" href="/storage/${plugin.getName()}/export"">Export</a>
              </td>
            </tr>
          </#if>
        </#list>
      </tbody>
    </table>
  </div>
  <div class="page-header">
  </div>
  <h4>Disabled Storage Plugins</h4>
  <div class="table-responsive">
    <table class="table">
      <tbody>
        <#list model as plugin>
          <#if plugin.enabled() == false>
            <tr>
              <td style="border:none; width:200px;">
                ${plugin.getName()}
              </td>
              <td style="border:none;">
                <a class="btn btn-primary" href="/storage/${plugin.getName()}">Update</a>
                <a class="btn btn-primary" onclick="doEnable('${plugin.getName()}', true)">Enable</a>
              </td>
            </tr>
          </#if>
        </#list>
      </tbody>
    </table>
  </div>
  <div class="page-header">
  </div>
  <div>
    <h4>New Storage Plugin</h4>
    <form class="form-inline" id="newStorage" role="form" action="/" method="GET">
      <div class="form-group">
        <input type="text" class="form-control" id="storageName" placeholder="Storage Name">
      </div>
      <button type="submit" class="btn btn-default" onclick="doSubmit()">Create</button>
      <br>
      <div>
      <label for="file1" class="btn btn-default">Choose an import file &nbsp;&nbsp;</label>
      <input id="file1" style="visibility:hidden;display:none;" type="file">
      <button type="submit" class="btn btn-default" onclick="doImport()">Import</button>
      </div>
    </form>
  </div>
  <script>
    function doSubmit() {
      var name = document.getElementById("storageName");
      var form = document.getElementById("newStorage");
      form.action = "/storage/" + name.value;
      form.submit();
    };
    function doImport() {
      var file = document.getElementById("file1");
      var form = document.getElementById("newStorage");
      form.action = "/storage/import";
      form.submit();
    };
    function doEnable(name, flag) {
      $.get("/storage/" + name + "/enable/" + flag, function(data) {
        location.reload();
      });
    };
  </script>
</#macro>

<@page_html/>
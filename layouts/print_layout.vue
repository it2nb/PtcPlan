<template>
  <v-app>
    <v-system-bar class="d-print-none pt-3" height="30" app lights-out>
      <v-toolbar-items class="mx-auto">
        <v-btn dark @click="print" class="title mr-2 rounded" color="primary">
          <v-icon class="mr-1" color="white">fas fa-print</v-icon>พิมพ์
        </v-btn>
        <v-btn dark @click.stop="Export2Doc('exportContent','ระบบบริหารจัดการแผนปฏิบัติราชการExport')" class="title mr-2 rounded" color="primary">
          <v-icon class="mr-1" color="white">fas fa-file-word</v-icon> Ms Word
        </v-btn>
      </v-toolbar-items>
    </v-system-bar>
    <nuxt id="exportContent" />
  </v-app>
</template>

<script>
  export default {
    data: () => ({

    }),
    methods: {
      print() {
        try {
          // Print for Safari browser
          document.execCommand('print', false, null)
        } catch {
          window.print()
        }
      },

      Export2Doc(element, filename) {
        var preHtml =
          "<html xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:w='urn:schemas-microsoft-com:office:word' xmlns='http://www.w3.org/TR/REC-html40'><head><meta charset='utf-8'><title>Export HTML To Doc</title></head><body>"
        var postHtml = "</body></html>"
        var html = preHtml + document.getElementById(element).innerHTML + postHtml

        var blob = new Blob(['\ufeff', html], {
          type: 'application/msword'
        })

        // Specify link url
        var url = 'data:application/vnd.ms-word;charset=utf-8,' + encodeURIComponent(html)

        // Specify file name
        filename = filename ? filename + '.doc' : 'document.doc'

        // Create download link element
        var downloadLink = document.createElement("a")

        document.body.appendChild(downloadLink)

        if (navigator.msSaveOrOpenBlob) {
          navigator.msSaveOrOpenBlob(blob, filename)
        } else {
          // Create a link to the file
          downloadLink.href = url

          // Setting the file name
          downloadLink.download = filename

          //triggering the function
          downloadLink.click()
        }

        document.body.removeChild(downloadLink)
      },
    },
    props: {
      source: String
    }
  }

</script>

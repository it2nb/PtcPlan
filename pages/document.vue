<template>
  <div class="container">
    <h2 class="col-12 col-md-5 px-0 fontBold white--text  ptcBg text-center rounded-br-xl rounded-tl-xl elevation-3">เอกสารเผยแพร่</h2>
    <div v-if="documenttypes">
      <v-tabs
        v-model="tab"
        centered
        fixed-tabs
        color="orange darken-4"
        background-color="green lighten-5"
        class="container mt-3"
      >
        <v-tab
          v-for="documenttype in documenttypes"
          :key="documenttype.key"
        >
          {{ documenttype.documenttypeTitle }}
        </v-tab>
      </v-tabs>
      <v-tabs-items
        v-model="tab"
        class="container px-md-12"
      >
        <v-tab-item
          v-for="documenttype in documenttypes"
          :key="documenttype.key"
        >
        <v-card class="py-md-5 px-md-8">
          <v-card-title class="ptcBg white--text font-weight-bold">
            {{ documenttype.documenttypeTitle }}
          </v-card-title>
          <v-card-text>
            <v-list>
              <v-list-item-group
                v-for="document in documenttype.documents"
                :key="document.key"
              >
                <v-list-item
                  link
                  :href="document.documentLink? documentPath+document.documentLink : ''"
                  target="_blank"
                >
                  <v-list-item-avatar v-if="document.documentCover">
                    <v-img :src="document.documentCover+'?t='+new Date()" contain></v-img>
                  </v-list-item-avatar>
                  <v-list-item-icon v-else>
                    <v-icon color="red darken-3">fas fa-file-pdf</v-icon>
                  </v-list-item-icon>
                  <v-list-item-content>
                    <v-list-item-title>
                      {{ document.documentTitle }}
                    </v-list-item-title>
                  </v-list-item-content>
                </v-list-item>
                <v-divider class="my-1"></v-divider>
              </v-list-item-group>
            </v-list>
          </v-card-text>
        </v-card>
          
        </v-tab-item>
      </v-tabs-items>
    </div>
  </div>
</template>
<script>
export default {
  data() {
    return {
      tab: 0,
      documenttypes: [],
      documentPath: null
    }
  },

  async mounted() {
    await this.getDocumentPath()
    await this.getDocumenttype()
  },

  methods: {
    async getDocumenttype() {
      let params = {
        token: this.$store.state.jwtToken,
        fn: "AllDetail"
      }
      let result = await this.$axios.$get('documenttype.php', {
        params:params
      })

      if(result.message == 'Success') {
        this.documenttypes = JSON.parse(JSON.stringify(result.documenttype))
        this.documenttypes = this.documenttypes.filter(documenttype=>documenttype.documentQty > 0)
        let mapCover = this.documenttypes.map(documenttype=>{
          if(documenttype.documents.length>0) {
            documenttype.documents.map(async document=>{
              document.documentCover = await this.getCover(document.documentID)
            })
          }
        })

        await Promise.all(mapCover)
      }
    },

    async getDocumentPath() {
        let result = await this.$axios.$get('document.doc.php', {
            params: {
                token: this.$store.state.jwtToken,
                function: 'documentPath'
            }
        })
        if(result.message == 'Success') {
            this.documentPath = result.documentPath
        }
    },

    async getCover(documentID) {
      let result = await this.$axios.$get('document.image.php', {
        params: {
          token: this.$store.state.jwtToken,
          documentID: documentID,
          function: 'documentImageGet'
        }
      })

       if(result.message == 'Success') {
        return result.documentImagePath+result.documentImages[0]
       } else {
        return ''
       }
    },
  },
}
</script>

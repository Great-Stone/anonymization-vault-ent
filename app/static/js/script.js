const { createApp } = Vue

const app = createApp({
  data() {
    return {
      nameOrg: '',
      nameEnc: '',
      snnOrg: '',
      snnEnc: '',
      phoneOrg: '',
      phoneEnc: '',
      emailOrg: '',
      emailEnc: '',
      cardNo: '',
      cardType: '',
      cardToken: '',
    }
  },
  methods: {
    sendVault: function(event) {
      let self = this
      if(this.nameOrg != '') {
        axios.get(`/name/${this.nameOrg}`)
        .then(function (response) {
          console.log(response.data)
          self.nameEnc = response.data
        }).catch(function (error) {
          console.log(error)
        });
      }
      if(this.snnOrg != '') {
        axios.get(`/ssn/${this.snnOrg}`)
        .then(function (response) {
          console.log(response.data)
          self.snnEnc = response.data
        }).catch(function (error) {
          console.log(error)
        });
      }
      if(this.phoneOrg != '') {
        axios.get(`/phone/${this.phoneOrg}`)
        .then(function (response) {
          console.log(response.data)
          self.phoneEnc = response.data
        }).catch(function (error) {
          console.log(error)
        });
      }
      if(this.emailOrg != '') {
        axios.get(`/encrypt/${this.emailOrg}`)
        .then(function (response) {
          console.log(response.data)
          self.emailEnc = response.data
        }).catch(function (error) {
          console.log(error)
        });
      }
      if(this.cardNo != '') {
        axios.get(`/tokenization`, {
          params: {
            cardno: this.cardNo,
            cardtype: this.cardType
          }
        })
        .then(function (response) {
          console.log(response.data)
          self.cardToken = response.data
        }).catch(function (error) {
          console.log(error)
        });
      }
    },
    getInfo: async function(event) {
      let self = this
      if(this.nameEnc != '' && this.nameEnc != this.nameOrg) {
        axios.get(`/name-dec/${this.nameEnc}`)
        .then(function (response) {
          console.log(response.data)
          self.nameEnc = response.data
        }).catch(function (error) {
          console.log(error)
        });
      }
      if(this.phoneEnc != '' && this.phoneEnc != this.phoneOrg) {
        axios.get(`/phone-dec/${this.phoneEnc}`)
        .then(function (response) {
          console.log(response.data)
          self.phoneEnc = response.data
        }).catch(function (error) {
          console.log(error)
        });
      }
      if(this.emailEnc.includes("vault:")) {
        axios.get(`/decrypt/${btoa(this.emailEnc)}`)
        .then(function (response) {
          console.log(response.data)
          self.emailEnc = response.data
        }).catch(function (error) {
          console.log(error)
        });
      }
      if(this.cardToken != '' && !this.cardToken.includes('expiration_time')) {
        const validateres = await axios.get(`/tokenvalidate/${this.cardToken}`)
        console.log(validateres.data)
        if(validateres.data){
          const metares = await axios.get(`/tokenmeta/${this.cardToken}`)
          this.cardToken = JSON.stringify(metares.data)
        }
      }
    }
  }
})

app.mount('#app')
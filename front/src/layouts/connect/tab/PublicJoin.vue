<template>
  <connect-form :title="$t('menu.joinPublicLobby')">
    <lang-select/>
    <id-input/>
    <pseudo-input/>
    <game-loop-select/>
    <template v-slot:button>
      <connect-btn @click="submit" :label="$t('join')"/>
    </template>
  </connect-form>
</template>
<style lang="scss">

</style>
<script lang="ts">
import ConnectBtn from 'src/components/form/ConnectButton.vue';
import ConnectForm from 'src/components/form/ConnectForm.vue';
import LangSelect from 'src/components/form/LanguageSelect.vue';
import PasswordInput from 'src/components/form/PasswordInput.vue';
import PseudoInput from 'src/components/form/PseudoInput.vue';
import IdInput from 'src/components/form/IdInput.vue';
import GameLoopSelect from 'src/components/form/GameLoopSelect.vue';
import { login, ConnectEvent, ConnectType } from 'src/mixins/connect';

import { defineComponent } from '@vue/composition-api';

export default defineComponent({
  name: 'PublicJoin',
  components: { ConnectForm, ConnectBtn, LangSelect, PasswordInput, PseudoInput, IdInput, GameLoopSelect },
  data() {
    return {
      password: ""
    }
  },
  methods: {
    submit() {
      var vm:any = this;
      var connectEvent:ConnectEvent = {
        type: ConnectType.PublicJoin
      }
      login(connectEvent);
    }
  }
});
</script>
<template>
  <div class="setting">
    <div class="span2 text-h3 q-py-lg">{{ $t('settingTab.settings') }}</div>
    <fullscreen-switch class="action-btn"/><theme-switch/>
    <p class="q-ma-none">SafeMode : </p><safe-mode-switch/>
    <lang-switch class="span2 strech"/>
    <volume-slider class="span2 strech"/>
    <shortcut-btn/>
  </div>
</template>
<style lang="scss">
.setting {
  display: grid;
  grid-template-columns: 1fr 1fr;
  padding: 15px;
  place-items: center;
  row-gap: 15px;
  .action-btn {
    padding: 5px;
  }
  .span2 {
  grid-column: span 2;
  }
  .strech {
    place-self: stretch;
  }
}

</style>
<script lang="ts">
import ThemeSwitch from 'src/components/setting/ThemeSwitch.vue';
import LangSwitch from 'src/components/setting/LangSwitch.vue';
import VolumeSlider from 'src/components/setting/VolumeSlider.vue';
import FullscreenSwitch from 'src/components/setting/FullscreenSwitch.vue';
import SafeModeSwitch from 'src/components/setting/SafeModeSwitch.vue';
import ShortcutBtn from 'src/components/setting/ShortcutButton.vue';

import { defineComponent } from '@vue/composition-api';

export default defineComponent({
  name: 'SettingTab',
  components: { ThemeSwitch, LangSwitch, VolumeSlider, FullscreenSwitch, SafeModeSwitch, ShortcutBtn }
});
</script>

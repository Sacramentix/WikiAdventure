<template>
  <div class="wait-screen row justify-center absolute-full">
    <div class="wait-container shadow-6">
      <div class="wait-slot justify-center">
        {{ players.length }} / 25
      </div>
      <q-separator/>
      <div class="wait-players">
        <div v-for="player in players" :key="player.id">
          <div>
            <q-icon :class="{ invisible: player.id != owner }" size="xs" class="owner" name="mdi-crown"/>
          </div>
          <div :class="{ self: player.id == self }">{{ player.pseudo }}</div>
        </div>
      </div>
      <q-separator/>
      <div class="wait-action justify-center">
        <div><!--Only to display tooltip over the disabled q btn -->
          <q-btn :disable="self != owner" push class="wait-start" label="start" @click="start()" icon="mdi-check-bold"/>
          <q-tooltip v-if="self != owner"  anchor="top middle" self="bottom middle" :offset="[10, 10]">
            Only <q-icon size="xs" class="owner" name="mdi-crown"/> {{ ownerPseudo }} can choose to start
          </q-tooltip>
        </div>
      </div>
    </div>
  </div>
</template>
<style lang="scss">
.wait-screen {
  overflow: hidden;
}
.wait-container {
  width: Max(50%, 500px);
  max-width: 100%;
  height: 95%;
  margin: 1.25%;
  border-radius: 6px;
  display: flex;
  flex-direction: column;
  @media screen and (max-width: 600px) {
    margin: 0;
    height: 100%;
    width: 100%;
    border-radius: 0;
  }
}
.wait-players {
  overflow-x: auto;
  overflow-y: scroll;
  display: flex;
  flex-direction: column;
  flex: 1;
  padding: 4px;
  div {
    flex: 0 0 auto;
    border-radius: 6px;
    margin: 1px;
    display: flex;
    flex-direction: row;
    align-items: end;
    padding: 3px 6px;
    div {
      padding: 1px 4px;
    }
  }
}
.wait-action, .wait-slot {
  display: inline-flex;
  flex: 0 0 auto;
  margin: 4px;
}
.wait-slot {
  font-size: 2em;
}
.body--dark {
  .wait-container {
    background: var(--w-color-almost-black);
  }
  .wait-players {
    background: var(--w-color-almost-black);
    div {
      background: #191919;
      div {
        color: var(--w-color-blue-white);
      }
      .self {
        color: var(--w-color-dark-teal);
      }
      .owner {
        color: var(--w-color-dark-teal);
      }
    }
  }
  .wait-slot {
    color: var(--w-color-blue-white);
  }
  .wait-start {
    background: var(--w-color-dark-teal);
    color: var(--w-color-blue-white);
  }
}
.body--light {
  .wait-container {
    background: var(--w-color-light-teal);
  }
  .wait-players {
    background: var(--w-color-light-teal);
    div {
      background: var(--w-color-blue-white);
      div {
        color: var(--w-color-almost-black);
      }
      .self {
        color: var(--w-color-dark-teal);
      }
      .owner {
        color: var(--w-color-dark-teal);
      }
    }
  }
  .wait-slot {
    color: var(--w-color-blue-white);
  }
  .wait-start {
    background: var(--w-color-dark-teal);
    color: var(--w-color-blue-white);
  }
}
</style>
<script lang="ts">
import { defineComponent } from '@vue/composition-api';
import { Player } from '../../../store/gameData/state';

export default defineComponent({
  name: 'Wait',
  computed: {
    players():Player[] {
      return (this.$store.state.gameData.players as Player[]).filter((p) => {return p.isConnected});
    },
    owner():number {
      return this.$store.state.gameData.owner;
    },
    ownerPseudo():string {
      var players = this.$store.state.gameData.players as Player[];
      for (var p of players) {
        if (p.id == this.$store.state.gameData.owner) return p.pseudo;
      }
      return;
    },
    self():number {
      return this.$store.state.gameData.self;
    }
  },
  methods: {
    start() {
      this.$store.dispatch('gameData/sendStart');
    }
  }
});
</script>
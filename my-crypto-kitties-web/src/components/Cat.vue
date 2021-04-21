<template>
  <div class="cat">
    <div class="ears">
      <div class="ear ear-left"></div>
      <div class="ear ear-right"></div>
    </div>
    <div class="body">
      <div class="eyes">
        <div class="eye">
          <div class="pupils"></div>
        </div>
        <div class="eye">
          <div class="pupils"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'Cat',
  props: {
    msg: String
  }
}
</script>

<style lang="less" scoped>
  .cat {
    .ears {
      display: flex;
      justify-content: space-between;
      width: 200px;
      position: relative;
      top: 70px;
      z-index: -1;

      .ear {
        background-color: #e58a46;
        width: 80px;
        height: 80px;

        &.ear-left {
          border-radius: 0 90%;
        }
        &.ear-right {
          border-radius: 90% 0;
        }
      }
    }

    .body {
      background-color: #d97930;
      width: 200px;
      height: 200px;
      border-radius: 50%;

      .eyes {
        top: 50px;
        display: flex;
        justify-content: space-around;
        position: relative;

        .eye {
          width: 50px;
          height: 40px;
          background-color: #ffffff;
          border-radius: 50%;

          .pupils {
            width: 34px;
            height: 34px;
            position: relative;
            top: 3px;
            left: 8px;
            background-color: black;
            border-radius: 50%;
          }
        }
      }
    }
  }
</style>

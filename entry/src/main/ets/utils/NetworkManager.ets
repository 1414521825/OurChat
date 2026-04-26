import { connection } from "@kit.NetworkKit";

export class NetworkManager {
  static init() {
    let conn = connection.createNetConnection();

    conn.on('netAvailable', () => {
      AppStorage.setOrCreate('isNetAvailable', true);
      console.info("网络连接成功~")
    });

    conn.on('netLost', () => {
      AppStorage.setOrCreate('isNetAvailable', false);
      console.info("网络连接失败~")
    });

    conn.register((err) => {});
  }
}
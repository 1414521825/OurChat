// 专门为路由传参定义的类
export class ChatRouteParams {
  id: string;
  name: string;

  constructor(id: string, name: string) {
    this.id = id;
    this.name = name;
  }
}
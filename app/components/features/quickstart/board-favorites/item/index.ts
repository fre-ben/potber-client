import Component from '@glimmer/component';
import { action } from '@ember/object';
import { service } from '@ember/service';
import RendererService from 'potber-client/services/renderer';
import LocalStorageService from 'potber-client/services/local-storage';
import { appConfig } from 'potber-client/config/app.config';
import { Boards } from 'potber-client/services/api/types';

export interface Signature {
  Args: {
    board: Boards.Read;
    inSidebar: boolean;
  };
}

export default class QuickstartBoardFavoriteComponent extends Component<Signature> {
  @service declare localStorage: LocalStorageService;
  @service declare renderer: RendererService;
  declare args: Signature['Args'];

  get originalUrl() {
    return `${appConfig.forumUrl}board.php?BID=${this.args.board.id}`;
  }

  @action handleLinkClick() {
    if (this.args.inSidebar && !this.renderer.isDesktop) {
      this.renderer.toggleLeftSidebar(false);
    }
  }

  @action remove() {
    const boards = [...(this.localStorage.boardFavorites || [])];
    const index = boards.indexOf(this.args.board);
    boards.splice(index, 1);
    const remainingIds = boards.map((board) => board.id);
    this.localStorage.setBoardFavorites(remainingIds);
  }
}

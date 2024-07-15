import Component from '@glimmer/component';
import Portal from 'ember-stargate/components/portal';
import NavHeader from '../../component/header';
import Button from 'potber-client/components/common/control/button';
import { service } from '@ember/service';
import DeviceManagerService from 'potber-client/services/device-manager';
import ModalService from 'potber-client/services/modal';
import t from 'ember-intl/helpers/t';
import { WritablePost } from 'potber-client/services/api/models/post';
import { WritableThread } from 'potber-client/services/api/models/thread';
import Menu from 'potber-client/components/common/control/menu';
import MenuCheckbox from 'potber-client/components/common/control/menu/checkbox';

interface Signature {
  Args: {
    formId: string;
    threadOrPost: WritablePost | WritableThread;
    title: string;
    subtitle?: string;
    loading?: boolean;
  };
}

export default class PostFormNav extends Component<Signature> {
  @service declare deviceManager: DeviceManagerService;
  @service declare modal: ModalService;

  get showControls() {
    return !this.deviceManager.isDesktop;
  }

  handleBack = () => {
    history.back();
  };

  handlePreview = () => {
    this.modal.postPreview({ post: this.post });
  };

  handleConvertUrlsChange = (value: boolean) => {
    this.post.convertUrls = value;
  };

  handleDisableBbCodeChange = (value: boolean) => {
    this.post.disableBbCode = value;
  };

  handleDisableEmojisChange = (value: boolean) => {
    this.post.disableEmojis = value;
  };

  get post() {
    const { threadOrPost } = this.args;
    if (threadOrPost instanceof WritableThread) {
      return threadOrPost.openingPost;
    } else {
      return threadOrPost;
    }
  }

  get isSaving() {
    return this.args.threadOrPost?.isSaving ?? false;
  }

  <template>
    <Portal @target='top-nav'>
      <NavHeader @title={{@title}} @subtitle={{@subtitle}} />
    </Portal>

    <Portal @target='bottom-nav'>
      <Button
        @text={{t 'misc.back'}}
        @icon='arrow-up'
        @size='square'
        @variant='primary-transparent'
        @onClick={{this.handleBack}}
        class='nav-element-left'
      />
      {{#if this.showControls}}
        <div class='flex-row align-items-center nav-element-right'>
          <Menu @position='top' @variant='primary-transparent' @icon='ellipsis'>
            <MenuCheckbox
              @text={{t 'route.post.form.convert-urls'}}
              @default={{this.post.convertUrls}}
              @onChange={{this.handleConvertUrlsChange}}
            />
            <MenuCheckbox
              @text={{t 'route.post.form.disable-bbcode'}}
              @default={{this.post.disableBbCode}}
              @onChange={{this.handleDisableBbCodeChange}}
            />
            <MenuCheckbox
              @text={{t 'route.post.form.disable-emojis'}}
              @default={{this.post.disableEmojis}}
              @onChange={{this.handleDisableEmojisChange}}
            />
          </Menu>

          <Button
            @icon='eye'
            @text={{t 'feature.post-form.preview'}}
            @variant='primary-transparent'
            @size='square'
            @type='button'
            @onClick={{this.handlePreview}}
          />
          <Button
            @icon='check'
            @text={{t 'feature.post-form.submit'}}
            @variant='primary-transparent'
            @size='square'
            @type='submit'
            @busy={{this.isSaving}}
            form={{@formId}}
          />
        </div>
      {{/if}}
    </Portal>
  </template>
}

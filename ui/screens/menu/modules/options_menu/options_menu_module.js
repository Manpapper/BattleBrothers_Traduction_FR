/*
 *  @Project:		Battle Brothers
 *	@Company:		Overhype Studios
 *
 *	@Copyright:		(c) Overhype Studios | 2013 - 2020
 * 
 *  @Author:		Overhype Studios
 *  @Date:			12.04.2017 (refactored: 03.10.2017)
 *  @Description:	Options Menu Module JS
 */
"use strict";

var OptionsMenuModule = function()
{
    this.mSQHandle   = null;
    this.mDataSource = new OptionsMenuModuleDatasource();

    // event listener
    this.mEventListener = null;

    // generic containers
    this.mContainer       = null;
    this.mDialogContainer = null;

    // content: panels
    this.mVideoPanel    = null;
    this.mAudioPanel    = null;
    this.mControlsPanel = null;
    this.mGameplayPanel = null;

    // tab - buttons
    this.mSwitchToVideoButton    = null;
    this.mSwitchToAudioButton    = null;
    this.mSwitchToControlsButton = null;
    this.mSwitchToGameplayButton = null;

    // buttons
    this.mOkButton    = null;
    this.mApplyButton = null;
    this.mCloseButton = null;

    // generics
    this.mIsVisible = false;

    this.createPanels();
};


OptionsMenuModule.prototype.isConnected = function ()
{
    return this.mSQHandle !== null;
};

OptionsMenuModule.prototype.onConnection = function (_handle)
{
	this.mSQHandle = _handle;
    this.mDataSource.onConnection(this.mSQHandle);

    // notify listener
    if (this.mEventListener !== null && ('onModuleOnConnectionCalled' in this.mEventListener))
    {
        this.mEventListener.onModuleOnConnectionCalled(this);
    }
};

OptionsMenuModule.prototype.onDisconnection = function ()
{
	this.mSQHandle = null;
    this.mDataSource.onDisconnection();

    // notify listener
    if (this.mEventListener !== null && ('onModuleOnDisconnectionCalled' in this.mEventListener))
    {
        this.mEventListener.onModuleOnDisconnectionCalled(this);
    }
};


OptionsMenuModule.prototype.createDIV = function (_parentDiv)
{
    var self = this;

    // create: dialog container
    this.mContainer = $('<div class="options-menu-module display-none"/>');
    _parentDiv.append(this.mContainer);
    this.mDialogContainer = this.mContainer.createDialog('Options', null, null /*Path.GFX + Asset.HEADER_TACTICAL_COMBAT_DIALOG*/, true, 'dialog-800-720-2');

    // create tabs
    var tabButtonsContainer = $('<div class="l-tab-button-bar"></div>');
    this.mDialogContainer.findDialogTabContainer().append(tabButtonsContainer);

    var layout = $('<div class="l-tab-button"/>');
    tabButtonsContainer.append(layout);
    this.mSwitchToVideoButton = layout.createTabTextButton("Video", function ()
    {
        self.switchToVideoPanel();
    }, null, 'tab-button', 7);

    layout = $('<div class="l-tab-button"/>');
    tabButtonsContainer.append(layout);
    this.mSwitchToAudioButton = layout.createTabTextButton("Audio", function ()
    {
        self.switchToAudioPanel();
    }, null, 'tab-button', 7);

    layout = $('<div class="l-tab-button"/>');
    tabButtonsContainer.append(layout);
    this.mSwitchToControlsButton = layout.createTabTextButton("Controls", function ()
    {
        self.switchToControlsPanel();
    }, null, 'tab-button', 7);

    layout = $('<div class="l-tab-button"/>');
    tabButtonsContainer.append(layout);
    this.mSwitchToGameplayButton = layout.createTabTextButton("Gameplay", function ()
    {
        self.switchToGameplayPanel();
    }, null, 'tab-button', 7);


    // create footer button bar
    var footerButtonBar = $('<div class="l-button-bar"></div>');
    this.mDialogContainer.findDialogFooterContainer().append(footerButtonBar);

    var layout = $('<div class="l-ok-button"/>');
    footerButtonBar.append(layout);
    this.mOkButton = layout.createTextButton("Ok", function ()
    {
        self.applyOptions(true);
    }, '', 1);

    layout = $('<div class="l-apply-button"/>');
    footerButtonBar.append(layout);
    this.mApplyButton = layout.createTextButton("Apply", function ()
    {
        self.applyOptions(false);
    }, '', 1);

    layout = $('<div class="l-cancel-button"/>');
    footerButtonBar.append(layout);
    this.mCloseButton = layout.createTextButton("Cancel", function ()
    {
        self.notifyBackendCancelButtonPressed();
    }, '', 1);

    this.mIsVisible = false;
};

OptionsMenuModule.prototype.destroyDIV = function ()
{
    // tab - buttons
    this.mSwitchToVideoButton.remove();
    this.mSwitchToVideoButton = null;
    this.mSwitchToAudioButton.remove();
    this.mSwitchToAudioButton = null;
    this.mSwitchToControlsButton.remove();
    this.mSwitchToControlsButton = null;
    this.mSwitchToGameplayButton.remove();
    this.mSwitchToGameplayButton = null;

    // buttons
    this.mOkButton.remove();
    this.mOkButton = null;
    this.mApplyButton.remove();
    this.mApplyButton = null;
    this.mCloseButton.remove();
    this.mCloseButton = null;

    this.mDialogContainer.empty();
    this.mDialogContainer.remove();
    this.mDialogContainer = null;

    this.mContainer.empty();
    this.mContainer.remove();
    this.mContainer = null;
};


OptionsMenuModule.prototype.bindTooltips = function ()
{
    /*
     this.mBrothersCountContainer.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.TacticalScreen.RoundInformationModule.BrothersCounter });
     */
};

OptionsMenuModule.prototype.unbindTooltips = function ()
{

};


OptionsMenuModule.prototype.createPanels = function ()
{
    this.mVideoPanel = new OptionsMenuModuleVideoPanel(this.mDataSource);
    this.mAudioPanel = new OptionsMenuModuleAudioPanel(this.mDataSource);
    this.mControlsPanel = new OptionsMenuModuleControlsPanel(this.mDataSource);
    this.mGameplayPanel = new OptionsMenuModuleGameplayPanel(this.mDataSource);
};

OptionsMenuModule.prototype.registerPanels = function ()
{
    var panelContainer = this.mContainer.findDialogContentContainer();
    this.mVideoPanel.register(panelContainer);
    this.mAudioPanel.register(panelContainer);
    this.mControlsPanel.register(panelContainer);
    this.mGameplayPanel.register(panelContainer);
};

OptionsMenuModule.prototype.unregisterPanels = function ()
{
    this.mVideoPanel.unregister();
    this.mAudioPanel.unregister();
    this.mControlsPanel.unregister();
    this.mGameplayPanel.unregister();
};


OptionsMenuModule.prototype.create = function(_parentDiv)
{
    this.createDIV(_parentDiv);
    this.registerPanels();
    this.bindTooltips();
};

OptionsMenuModule.prototype.destroy = function()
{
    this.unbindTooltips();
    this.unregisterPanels();
    this.destroyDIV();
};


OptionsMenuModule.prototype.register = function (_parentDiv)
{
    console.log('OptionsMenuModule::REGISTER');

    if (this.mContainer !== null)
    {
        console.error('ERROR: Failed to register Options Menu Module. Reason: Options Menu Module is already initialized.');
        return;
    }

    if (_parentDiv !== null && typeof(_parentDiv) == 'object')
    {
        this.create(_parentDiv);
    }
};

OptionsMenuModule.prototype.unregister = function ()
{
    console.log('OptionsMenuModule::UNREGISTER');

    if (this.mContainer === null)
    {
        console.error('ERROR: Failed to unregister Options Menu Module. Reason: Options Menu Module is not initialized.');
        return;
    }

    this.destroy();
};

OptionsMenuModule.prototype.isRegistered = function ()
{
    if (this.mContainer !== null)
    {
        return this.mContainer.parent().length !== 0;
    }

    return false;
};


OptionsMenuModule.prototype.registerEventListener = function(_listener)
{
    this.mEventListener = _listener;
};


OptionsMenuModule.prototype.show = function (_data)
{
    this.mDataSource.loadOptions(_data);

    var self = this;

    var offset = -(this.mContainer.parent().width() + this.mContainer.width());
    this.mContainer.css({ 'left': offset });
    this.mContainer.removeClass('display-none').addClass('display-block');
    this.mContainer.velocity("finish", true).velocity({ opacity: 1, left: '0', right: '0' },
    {
        duration: Constants.SCREEN_SLIDE_IN_OUT_DELAY,
        easing: 'swing',
        begin: function ()
        {
            //$(this).css({ 'left' : '', 'right' : '' });
            self.notifyBackendModuleAnimating();
            self.mSwitchToVideoButton.selectTabTextButton(true);

        },
        complete: function ()
        {
            self.mIsVisible = true;
            //$(this).addClass('is-center');
            self.notifyBackendModuleShown();
        }
    });
};

OptionsMenuModule.prototype.hide = function ()
{
    var self = this;

    var offset = -(this.mContainer.parent().width() + this.mContainer.width());
    this.mContainer.velocity("finish", true).velocity({ opacity: 0, left: offset },
    {
        duration: Constants.SCREEN_SLIDE_IN_OUT_DELAY,
        easing: 'swing',
        begin: function ()
        {
            //$(this).css({ 'left' : '', 'right' : '' });
            //$(this).removeClass('is-center');
            self.notifyBackendModuleAnimating();
        },
        complete: function ()
        {
            self.mIsVisible = false;
            $(this).removeClass('display-block').addClass('display-none');
            self.notifyBackendModuleHidden();
        }
    });
};

/*
OptionsMenuModule.prototype.show = function (_data)
{
    this.mDataSource.loadOptions(_data);

    var self = this;

    var offset = -(this.mContainer.parent().width() + this.mContainer.width());
    this.mContainer.css({ 'left': offset });
    this.mContainer.removeClass('display-none').addClass('display-block');
    this.mContainer.stop(true).animate({ opacity: 1, left: '0', right: '0' },
    {
        duration: Constants.SCREEN_SLIDE_IN_OUT_DELAY,
        easing: 'swing',
        start: function ()
        {
            //$(this).css({ 'left' : '', 'right' : '' });
            self.notifyBackendModuleAnimating();
            self.mSwitchToVideoButton.selectTabTextButton(true);

        },
        always: function ()
        {
            self.mIsVisible = true;
            //$(this).addClass('is-center');
            self.notifyBackendModuleShown();
        }
    });
};

OptionsMenuModule.prototype.hide = function ()
{
    var self = this;

    var offset = -(this.mContainer.parent().width() + this.mContainer.width());
    this.mContainer.stop(true).animate({ opacity: 0, left: offset },
    {
        duration: Constants.SCREEN_SLIDE_IN_OUT_DELAY,
        easing: 'swing',
        start: function ()
        {
            //$(this).css({ 'left' : '', 'right' : '' });
            //$(this).removeClass('is-center');
            self.notifyBackendModuleAnimating();
        },
        always: function ()
        {
            self.mIsVisible = false;
            $(this).removeClass('display-block').addClass('display-none');
            self.notifyBackendModuleHidden();
        }
    });
};
*/

OptionsMenuModule.prototype.isVisible = function ()
{
    return this.mIsVisible;
};


OptionsMenuModule.prototype.switchToVideoPanel = function ()
{
    this.mAudioPanel.hide();
    this.mControlsPanel.hide();
    this.mGameplayPanel.hide();
    this.mVideoPanel.show();
};

OptionsMenuModule.prototype.switchToAudioPanel = function ()
{
    this.mVideoPanel.hide();
    this.mControlsPanel.hide();
    this.mGameplayPanel.hide();
    this.mAudioPanel.show();
};

OptionsMenuModule.prototype.switchToControlsPanel = function ()
{
    this.mVideoPanel.hide();
    this.mAudioPanel.hide();
    this.mGameplayPanel.hide();
    this.mControlsPanel.show();
};

OptionsMenuModule.prototype.switchToGameplayPanel = function ()
{
    this.mVideoPanel.hide();
    this.mAudioPanel.hide();
    this.mControlsPanel.hide();
    this.mGameplayPanel.show();
};

OptionsMenuModule.prototype.applyOptions = function (_close)
{
    this.mDataSource.applyOptions();
    if (_close)
    {
        this.notifyBackendOkButtonPressed();
    }
};

OptionsMenuModule.prototype.resetOptions = function ()
{
    this.mDataSource.loadDefaults();
};


OptionsMenuModule.prototype.notifyBackendModuleShown = function ()
{
    if (this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onModuleShown');
    }
};

OptionsMenuModule.prototype.notifyBackendModuleHidden = function ()
{
    if (this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onModuleHidden');
    }
};

OptionsMenuModule.prototype.notifyBackendModuleAnimating = function ()
{
    if (this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onModuleAnimating');
    }
};

OptionsMenuModule.prototype.notifyBackendOkButtonPressed = function ()
{
	if (this.mSQHandle !== null)
	{
		SQ.call(this.mSQHandle, 'onOkButtonPressed');
	}
};

OptionsMenuModule.prototype.notifyBackendCancelButtonPressed = function ()
{
    if (this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onCancelButtonPressed');
    }
};
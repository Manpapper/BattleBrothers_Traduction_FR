/*
 *  @Project:		Battle Brothers
 *	@Company:		Overhype Studios
 *
 *	@Copyright:		(c) Overhype Studios | 2013 - 2020
 * 
 *  @Author:		Overhype Studios
 *  @Date:			15.10.2017
 *  @Description:	Tactical Combat Result Screen JS
 */
"use strict";


var TacticalCombatResultScreen = function()
{
	this.mSQHandle = null;
    this.mDataSource = new TacticalCombatResultScreenDatasource();

	// generic containers
	this.mContainer = null;
    this.mDialogContainer = null;

    // content: panels
    this.mStatisticsPanel = null;
    this.mLootPanel = null;

    // buttons
    this.mSwitchToStatisticsButton = null;
    this.mSwitchToLootButton = null;
    this.mLeaveButton = null;

    this.createPanels();
    this.registerDatasourceListener();
};


TacticalCombatResultScreen.prototype.isConnected = function ()
{
    return this.mSQHandle !== null;
};

TacticalCombatResultScreen.prototype.onConnection = function (_handle)
{
	//if (typeof(_handle) == 'string')
	{
		this.mSQHandle = _handle;
        this.mDataSource.onConnection(this.mSQHandle);

		this.register($('.root-screen'));
	}
};

TacticalCombatResultScreen.prototype.onDisconnection = function ()
{
	this.mSQHandle = null;
    this.mDataSource.onDisconnection();

	this.unregister();
};


TacticalCombatResultScreen.prototype.createDIV = function (_parentDiv)
{
    var self = this;

	// create: containers (init hidden!)
	this.mContainer = $('<div class="tactical-combat-result-screen ui-control dialog-modal-background display-none opacity-none"/>');
    _parentDiv.append(this.mContainer);

    // create: dialog container
    var dialogLayout = $('<div class="l-dialog-container"/>');
    this.mContainer.append(dialogLayout);
    this.mDialogContainer = dialogLayout.createDialog('Titre', 'SubTitle', null /*Path.GFX + Asset.HEADER_COMBAT_RESULT_DIALOG*/, true, 'dialog-1024-768');

    // create tabs
    var tabButtonsContainer = $('<div class="l-tab-container"/>');
    this.mDialogContainer.findDialogTabContainer().append(tabButtonsContainer);

    var layout = $('<div class="l-tab-button"/>');
    tabButtonsContainer.append(layout);
    this.mSwitchToStatisticsButton = layout.createTabTextButton("Statistiques", function()
    {
        self.mLeaveButton.changeButtonText("Continuer");
		self.switchToStatisticsPanel();
    }, null, 'tab-button', 7);

    layout = $('<div class="l-tab-button"/>');
    tabButtonsContainer.append(layout);
    this.mSwitchToLootButton = layout.createTabTextButton("Butin", function ()
    {
        self.mLeaveButton.changeButtonText("Quitter");
		self.switchToLootPanel();
    }, null, 'tab-button', 7);


    // create content


    // create footer button bar
    var footerButtonBar = $('<div class="l-button-bar"></div>');
    this.mDialogContainer.findDialogFooterContainer().append(footerButtonBar);

    // create: buttons
    var layout = $('<div class="l-leave-button"/>');
    footerButtonBar.append(layout);
    this.mLeaveButton = layout.createTextButton("Continuer", function ()
    {
        
		if(self.mLootPanel.isVisible() || !self.mSwitchToLootButton.isEnabled())
		{
			self.notifyBackendLeaveButtonPressed();
		}
		else
		{
			self.mSwitchToLootButton.click();
// 			self.mLeaveButton.changeButtonText("Leave");
// 			self.switchToLootPanel();
		}

    }, '', 1);
};

TacticalCombatResultScreen.prototype.destroyDIV = function ()
{
    this.mSwitchToStatisticsButton.remove();
    this.mSwitchToStatisticsButton = null;
    this.mSwitchToLootButton.remove();
    this.mSwitchToLootButton = null;
    this.mLeaveButton.remove();
    this.mLeaveButton = null;

    this.mDialogContainer.empty();
    this.mDialogContainer.remove();
    this.mDialogContainer = null;

    this.mContainer.empty();
    this.mContainer.remove();
    this.mContainer = null;
};


TacticalCombatResultScreen.prototype.registerDatasourceListener = function()
{
    this.mDataSource.addListener(TacticalCombatResultScreenDatasourceIdentifier.CombatInformation.Loaded, jQuery.proxy(this.onCombatInformation, this));
};


TacticalCombatResultScreen.prototype.bindTooltips = function ()
{
    //this.mLeaveButton.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.TacticalCombatResultScreen.LeaveButton });
};

TacticalCombatResultScreen.prototype.unbindTooltips = function ()
{
    //this.mLeaveButton.unbindTooltip();
};


TacticalCombatResultScreen.prototype.createPanels = function ()
{
    this.mLootPanel = new TacticalCombatResultScreenLootPanel(this.mDataSource);
    this.mStatisticsPanel = new TacticalCombatResultScreenStatisticsPanel(this.mDataSource);
};

TacticalCombatResultScreen.prototype.registerPanels = function ()
{
    var panelContainer = this.mContainer.findDialogContentContainer();
    this.mStatisticsPanel.register(panelContainer);
    this.mLootPanel.register(panelContainer);
};

TacticalCombatResultScreen.prototype.unregisterPanels = function ()
{
    this.mStatisticsPanel.unregister();
    this.mLootPanel.unregister();
};


TacticalCombatResultScreen.prototype.create = function(_parentDiv)
{
    this.createDIV(_parentDiv);
    this.registerPanels();
    this.bindTooltips();

    this.mSwitchToStatisticsButton.selectTabTextButton(true);
    //this.mSwitchToLootButton.selectTabTextButton(true);
};

TacticalCombatResultScreen.prototype.destroy = function()
{
    this.unbindTooltips();
    this.unregisterPanels();
    this.destroyDIV();
};


TacticalCombatResultScreen.prototype.register = function (_parentDiv)
{
    console.log('TacticalCombatResultScreen::REGISTER');

    if (this.mContainer !== null)
    {
        console.error('ERROR: Failed to register Tactical Combat Result Screen. Reason: Tactical Combat Result is already initialized.');
        return;
    }

    if (_parentDiv !== null && typeof(_parentDiv) == 'object')
    {
        this.create(_parentDiv);
    }
};

TacticalCombatResultScreen.prototype.unregister = function ()
{
    console.log('TacticalCombatResultScreen::UNREGISTER');

    if (this.mContainer === null)
    {
        console.error('ERROR: Failed to unregister Tactical Combat Result Screen. Reason: Tactical Combat Result Screen is not initialized.');
        return;
    }

    this.destroy();
};


TacticalCombatResultScreen.prototype.show = function (_data)
{
    this.mDataSource.loadFromData(_data);

    var self = this;
    this.mContainer.velocity("finish", true).velocity({ opacity: 1 },
    {
        duration: Constants.SCREEN_FADE_IN_OUT_DELAY,
        easing: 'swing',
        begin: function ()
        {
            $(this).removeClass('display-none').addClass('display-block');
            self.notifyBackendOnAnimating();
        },
        complete: function ()
        {
            self.mIsVisible = true;
            self.notifyBackendOnShown();
        }
    });
};

TacticalCombatResultScreen.prototype.hide = function ()
{
    var self = this;

    this.mContainer.velocity("finish", true).velocity({ opacity: 0 },
    {
        duration: Constants.SCREEN_FADE_IN_OUT_DELAY,
        easing: 'swing',
        begin: function ()
        {
            self.notifyBackendOnAnimating();
        },
        complete: function ()
        {
            self.mIsVisible = false;
            $(this).removeClass('display-block').addClass('display-none');
            self.notifyBackendOnHidden();
        }
    });
};

TacticalCombatResultScreen.prototype.loadCombatInformation = function ()
{
    this.mDataSource.loadCombatInformation();
};

TacticalCombatResultScreen.prototype.loadStatistics = function ()
{
    this.mDataSource.loadStatistics();
};

TacticalCombatResultScreen.prototype.loadItemLists = function ()
{
    this.mDataSource.loadStashList();
    this.mDataSource.loadFoundLootList();
};

TacticalCombatResultScreen.prototype.loadStashList = function ()
{
    this.mDataSource.loadStashList();
};

TacticalCombatResultScreen.prototype.loadFoundLootList = function ()
{
    this.mDataSource.loadFoundLootList();
};

TacticalCombatResultScreen.prototype.switchToStatisticsPanel = function ()
{
    this.mLootPanel.hide();
    this.mStatisticsPanel.show();
};

TacticalCombatResultScreen.prototype.switchToLootPanel = function ()
{
    this.mStatisticsPanel.hide();
    this.mLootPanel.show();
};


TacticalCombatResultScreen.prototype.getModule = function (_name)
{
	switch(_name)
	{
        default: return null;
	}
};

TacticalCombatResultScreen.prototype.getModules = function ()
{
	return [
    ];
};


TacticalCombatResultScreen.prototype.onCombatInformation = function (_dataSource, _data)
{
    if (_data === undefined || _data === null || !(typeof(_data) === 'object'))
    {
        return;
    }

    if (TacticalCombatResultScreenIdentifier.CombatInformation.Result.Key in _data &&
        _data[TacticalCombatResultScreenIdentifier.CombatInformation.Result.Key] !== null)
    {
        var enableLootButton = (_data['result'] === TacticalCombatResultScreenIdentifier.CombatInformation.Result.Win || _data['arena'] == true) && _data['loot'];
        this.mSwitchToLootButton.enableButton(enableLootButton);

		if(!enableLootButton)
			this.mLeaveButton.changeButtonText("Leave");
    }

    if (TacticalCombatResultScreenIdentifier.CombatInformation.Title in _data &&
        _data[TacticalCombatResultScreenIdentifier.CombatInformation.Title] !== null)
    {
        this.mDialogContainer.findDialogTitle().html(_data[TacticalCombatResultScreenIdentifier.CombatInformation.Title]);
    }

    if (TacticalCombatResultScreenIdentifier.CombatInformation.SubTitle in _data &&
        _data[TacticalCombatResultScreenIdentifier.CombatInformation.SubTitle] !== null)
    {
        this.mDialogContainer.findDialogSubTitle().html(_data[TacticalCombatResultScreenIdentifier.CombatInformation.SubTitle]);
    }
};



TacticalCombatResultScreen.prototype.notifyBackendOnConnected = function ()
{
	SQ.call(this.mSQHandle, 'onScreenConnected');
};

TacticalCombatResultScreen.prototype.notifyBackendOnDisconnected = function ()
{
    if (this.mSQHandle != null)
    {
        SQ.call(this.mSQHandle, 'onScreenDisconnected');
    }
};

TacticalCombatResultScreen.prototype.notifyBackendOnShown = function ()
{
    SQ.call(this.mSQHandle, 'onScreenShown');
};

TacticalCombatResultScreen.prototype.notifyBackendOnHidden = function ()
{
    if (this.mSQHandle != null)
    {
        SQ.call(this.mSQHandle, 'onScreenHidden');
    }
};

TacticalCombatResultScreen.prototype.notifyBackendOnAnimating = function ()
{
    if (this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onScreenAnimating');
    }
};

TacticalCombatResultScreen.prototype.notifyBackendLeaveButtonPressed = function ()
{
    SQ.call(this.mSQHandle, 'onLeaveButtonPressed');
};
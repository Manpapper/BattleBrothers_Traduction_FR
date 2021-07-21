/*
 *  @Project:		Battle Brothers
 *	@Company:		Overhype Studios
 *
 *	@Copyright:		(c) Overhype Studios | 2013 - 2020
 * 
 *  @Author:		Overhype Studios
 *  @Date:			01.12.2013 (refactored: 02.10.2017)
 *  @Description:	Scenario Menu Module JS
 */
"use strict";

var ScenarioMenuModule = function()
{
	this.mSQHandle = null;

    // event listener
    this.mEventListener = null;

	// generic containers
	this.mContainer = null;
    this.mDialogContainer = null;

    // scenario list container
	this.mListContainer = null;
    this.mListScrollContainer = null;
	this.mDescriptionContainer = null;
	this.mDescriptionScrollContainer = null;

	// buttons
	this.mPlayButton  = null;

    // generics
    this.mIsVisible = false;
};


ScenarioMenuModule.prototype.isConnected = function ()
{
    return this.mSQHandle !== null;
};

ScenarioMenuModule.prototype.onConnection = function (_handle)
{
	//if (typeof(_handle) == 'string')
	{
		this.mSQHandle = _handle;

        // notify listener
        if (this.mEventListener !== null && ('onModuleOnConnectionCalled' in this.mEventListener)) {
            this.mEventListener.onModuleOnConnectionCalled(this);
        }
	}
};

ScenarioMenuModule.prototype.onDisconnection = function ()
{
	this.mSQHandle = null;

    // notify listener
    if (this.mEventListener !== null && ('onModuleOnDisconnectionCalled' in this.mEventListener)) {
        this.mEventListener.onModuleOnDisconnectionCalled(this);
    }
};


ScenarioMenuModule.prototype.createDIV = function (_parentDiv)
{
    var self = this;

    // create: dialog container
    this.mContainer = $('<div class="scenario-menu-module ui-control display-none"/>');
    _parentDiv.append(this.mContainer);
    this.mDialogContainer = this.mContainer.createDialog('Choisissez un Scénario', null, null, true, 'dialog-800-720-2' /*Path.GFX + Asset.HEADER_TACTICAL_COMBAT_DIALOG*/);

    // create content
    var content = this.mContainer.findDialogContentContainer();
    var scenarioListContainerLayout = $('<div class="l-list-container"></div>');
    content.append(scenarioListContainerLayout);
    this.mListContainer = scenarioListContainerLayout.createList(18);
    this.mListScrollContainer = this.mListContainer.findListScrollContainer();

    var descriptionContainerLayout = $('<div class="l-description-container"></div>');
    content.append(descriptionContainerLayout);
    this.mDescriptionContainer = descriptionContainerLayout.createList(10, 'description-font-medium font-color-description');
    this.mDescriptionScrollContainer = this.mDescriptionContainer.findListScrollContainer();

    // create footer button bar
    var footerButtonBar = $('<div class="l-button-bar"></div>');
    this.mDialogContainer.findDialogFooterContainer().append(footerButtonBar);

    var layout = $('<div class="l-play-button"/>');
    footerButtonBar.append(layout);
    this.mPlayButton = layout.createTextButton("Jouer", function ()
    {
        // find current selected and show its description
        var selectedEntry = self.mListScrollContainer.find('.is-selected:first');
        if (selectedEntry.length > 0)
        {
            var scenarioData = selectedEntry.data('scenario');
            self.notifyBackendPlayButtonPressed(scenarioData[ScenarioMenuModuleIdentifier.Scenario.Id]);
        }
    }, '', 1);
    this.mPlayButton.enableButton(false);

    layout = $('<div class="l-cancel-button"/>');
    footerButtonBar.append(layout);
    layout.createTextButton("Annuler", function ()
    {
        self.notifyBackendCancelButtonPressed();
    }, '', 1);

    this.mIsVisible = false;
};

ScenarioMenuModule.prototype.destroyDIV = function ()
{
    // scenario list container
    this.mListContainer.destroyList();
    this.mListContainer = null;
    this.mListScrollContainer = null;
    this.mDescriptionContainer.destroyList();
    this.mDescriptionContainer = null;
    this.mDescriptionScrollContainer = null;

    // buttons
    this.mPlayButton.remove();
    this.mPlayButton  = null;

    this.mDialogContainer.empty();
    this.mDialogContainer.remove();
    this.mDialogContainer = null;

    this.mContainer.empty();
    this.mContainer.remove();
    this.mContainer = null;
};


ScenarioMenuModule.prototype.bindTooltips = function ()
{
    /*
     this.mBrothersCountContainer.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.TacticalScreen.RoundInformationModule.BrothersCounter });
     */
};

ScenarioMenuModule.prototype.unbindTooltips = function ()
{

};


ScenarioMenuModule.prototype.create = function(_parentDiv)
{
    this.createDIV(_parentDiv);
    this.bindTooltips();
};

ScenarioMenuModule.prototype.destroy = function()
{
    this.unbindTooltips();
    this.destroyDIV();
};


ScenarioMenuModule.prototype.register = function (_parentDiv)
{
    console.log('ScenarioMenuModule::REGISTER');

    if (this.mContainer !== null)
    {
        console.error('ERROR: Failed to register Scenario Menu Module. Reason: Scenario Menu Module is already initialized.');
        return;
    }

    if (_parentDiv !== null && typeof(_parentDiv) == 'object')
    {
        this.create(_parentDiv);
    }
};

ScenarioMenuModule.prototype.unregister = function ()
{
    console.log('ScenarioMenuModule::UNREGISTER');

    if (this.mContainer === null)
    {
        console.error('ERROR: Failed to unregister Scenario Menu Module. Reason: Scenario Menu Module is not initialized.');
        return;
    }

    this.destroy();
};

ScenarioMenuModule.prototype.isRegistered = function ()
{
    if (this.mContainer !== null)
    {
        return this.mContainer.parent().length !== 0;
    }

    return false;
};


ScenarioMenuModule.prototype.registerEventListener = function(_listener)
{
    this.mEventListener = _listener;
};


ScenarioMenuModule.prototype.show = function (_data)
{
    // query data
    if (_data === null)
    {
        console.error('ERROR: Failed to show Scenario Menu Module. Reason: Invalid data.');
        return;
    }

    this.addScenariosToList(_data);

    var self = this;
    var offset = -(this.mContainer.parent().width() + this.mContainer.width());
    this.mContainer.css({ 'left' : offset });
    this.mContainer.velocity("finish", true).velocity({ opacity: 1, left: '0', right: '0' },
    {
        duration: Constants.SCREEN_SLIDE_IN_OUT_DELAY,
        easing: 'swing',
        begin: function ()
        {
            //$(this).css({ 'left' : '', 'right' : '' });
            $(this).removeClass('display-none').addClass('display-block');
            self.notifyBackendModuleAnimating();
        },
        complete: function ()
        {
            self.mIsVisible = true;
            //$(this).addClass('is-center');
            self.notifyBackendModuleShown();
        }
    });
};

ScenarioMenuModule.prototype.hide = function ()
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
            $(this).removeClass('is-center');
            self.notifyBackendModuleAnimating();
        },
        complete: function ()
        {
            self.mIsVisible = false;
            self.mListScrollContainer.empty();
            $(this).removeClass('display-block').addClass('display-none');
            self.notifyBackendModuleHidden();
        }
    });
};

ScenarioMenuModule.prototype.isVisible = function ()
{
    return this.mIsVisible;
};


ScenarioMenuModule.prototype.addScenarioEntryToList = function (_data)
{
    var row = $('<div class="l-row"/>');
	var entry = $('<div class="list-entry list-entry-small"><span class="label text-font-normal font-color-label">' + _data[ScenarioMenuModuleIdentifier.Scenario.Name] + '</span></div></div>');
    entry.data('scenario', _data);
	entry.click(this, this.onSelectScenario);
	entry.mouseenter(this, this.onMouseHoverScenario);
	entry.mouseleave(this, this.onMouseLeaveScenario);
    row.append(entry);
	this.mListScrollContainer.append(row);
};

ScenarioMenuModule.prototype.addScenariosToList = function (_scenarios)
{
	if (_scenarios !== null && jQuery.isArray(_scenarios))
	{
		this.mListScrollContainer.empty();

		for (var i = 0; i < _scenarios.length; ++i)
		{
			if (!(ScenarioMenuModuleIdentifier.Scenario.Id in _scenarios[i]))
			{
				console.error('ERROR: Failed to find "id" field while interpreting scenario data.');
				continue;
			}

			if (!(ScenarioMenuModuleIdentifier.Scenario.Name in _scenarios[i]))
			{
				console.error('ERROR: Failed to find "name" field while interpreting scenario data. Id: ' + _scenarios[i][ScenarioMenuModuleIdentifier.Scenario.Id]);
				continue;
			}

			this.addScenarioEntryToList(_scenarios[i]);
		}

		this.selectFirstScenario();
	}
};


ScenarioMenuModule.prototype.onSelectScenario = function(_event)
{
	var self = _event.data;
	var buttonDiv = $(this);

	// check if this is already selected
	if (buttonDiv.hasClass('is-selected') !== true)
	{
		// deselect all entries first
		self.mListScrollContainer.find('.is-selected:first').each(function (index, el)
		{
			$(el).removeClass('is-selected');
		});

		buttonDiv.addClass('is-selected');

        self.mPlayButton.enableButton(true);
	}
};

ScenarioMenuModule.prototype.onMouseHoverScenario = function(_event)
{
	var self = _event.data;
	var buttonDiv = $(this);

	// show description
	self.updateDescription(buttonDiv.data('scenario'));
};

ScenarioMenuModule.prototype.onMouseLeaveScenario = function(_event)
{
	var self = _event.data;
	
	// find current selected and show its description
	var selectedEntry = self.mListScrollContainer.find('.is-selected:first');
	if (selectedEntry.length > 0)
	{
		self.updateDescription(selectedEntry.data('scenario'));
	}
};


ScenarioMenuModule.prototype.selectFirstScenario = function()
{
	// deselect all entries first
    this.mListScrollContainer.find('.is-selected').each(function (index, el)
    {
		$(el).removeClass('is-selected');
	});

	var firstEntry = this.mListScrollContainer.find('.l-row:first');
    if (firstEntry.length > 0)
    {
        var entry = firstEntry.find('.list-entry:first');
        entry.addClass('is-selected');
        this.updateDescription(entry.data('scenario'));
        this.mPlayButton.enableButton(true);
    }
};

ScenarioMenuModule.prototype.updateDescription = function (_data)
{
	if (_data !== null && ScenarioMenuModuleIdentifier.Scenario.Description in _data && typeof(_data[ScenarioMenuModuleIdentifier.Scenario.Description]) == 'string')
	{
        var parsedText = XBBCODE.process(
        {
			text: _data[ScenarioMenuModuleIdentifier.Scenario.Description],
			removeMisalignedTags: false,
			addInLineBreaks: true
		});
									
		this.mDescriptionScrollContainer.html(parsedText.html);
	}
	else
	{
		console.error('ERROR: Failed to find "description" field while interpreting scenario data. Id: ' + _data[ScenarioMenuModuleIdentifier.Scenario.Id]);
	}
};


ScenarioMenuModule.prototype.notifyBackendModuleShown = function ()
{
    SQ.call(this.mSQHandle, 'onModuleShown');
};

ScenarioMenuModule.prototype.notifyBackendModuleHidden = function ()
{
    SQ.call(this.mSQHandle, 'onModuleHidden');
};

ScenarioMenuModule.prototype.notifyBackendModuleAnimating = function ()
{
    SQ.call(this.mSQHandle, 'onModuleAnimating');
};

ScenarioMenuModule.prototype.notifyBackendPlayButtonPressed = function (_scenarioId)
{
	SQ.call(this.mSQHandle, 'onPlayButtonPressed', _scenarioId);
};

ScenarioMenuModule.prototype.notifyBackendCancelButtonPressed = function ()
{
    SQ.call(this.mSQHandle, 'onCancelButtonPressed');
};
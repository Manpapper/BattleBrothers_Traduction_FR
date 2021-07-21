
"use strict";

var WorldTownScreenTrainingDialogModule = function(_parent)
{
	this.mSQHandle = null;
    this.mParent = _parent;

	this.mRoster = null;

    // event listener
    this.mEventListener = null;

	// generic containers
	this.mContainer = null;
    this.mDialogContainer = null;
    this.mListContainer = null;
    this.mListScrollContainer = null;
    this.mNoInjuredLabel = null;

    this.mDetailsPanel = {
        Container: null,
        CharacterImage: null,
        CharacterName: null,
        ScrollContainer: null,
		ScrollContainerList: null
    };
    // assets labels
	this.mAssets = new WorldTownScreenAssets(_parent);

    // buttons
    this.mLeaveButton = null;

    // generics
    this.mIsVisible = false;

    // selected entry
    this.mSelectedEntry = null;
};


WorldTownScreenTrainingDialogModule.prototype.isConnected = function ()
{
    return this.mSQHandle !== null;
};

WorldTownScreenTrainingDialogModule.prototype.onConnection = function (_handle)
{
	this.mSQHandle = _handle;

    // notify listener
    if (this.mEventListener !== null && ('onModuleOnConnectionCalled' in this.mEventListener))
	{
        this.mEventListener.onModuleOnConnectionCalled(this);
    }
};

WorldTownScreenTrainingDialogModule.prototype.onDisconnection = function ()
{
	this.mSQHandle = null;

    // notify listener
    if (this.mEventListener !== null && ('onModuleOnDisconnectionCalled' in this.mEventListener))
	{
        this.mEventListener.onModuleOnDisconnectionCalled(this);
    }
};

WorldTownScreenTrainingDialogModule.prototype.createDIV = function (_parentDiv)
{
    var self = this;

    // create: containers (init hidden!)
    this.mContainer = $('<div class="l-training-dialog-container display-none opacity-none"/>');
    _parentDiv.append(this.mContainer);
    this.mDialogContainer = this.mContainer.createDialog('Salle d\'Entraînement', '', '', true, 'dialog-1024-768');

	// create tabs
    var tabButtonsContainer = $('<div class="l-tab-container"/>');
    this.mDialogContainer.findDialogTabContainer().append(tabButtonsContainer);

	// create assets
    this.mAssets.createDIV(tabButtonsContainer);

	// create content
    var content = this.mDialogContainer.findDialogContentContainer();

	// left column
    var column = $('<div class="column is-left"/>');
    content.append(column);
    var listContainerLayout = $('<div class="l-list-container"/>');
    column.append(listContainerLayout);
    this.mListContainer = listContainerLayout.createList(8.85);
    this.mListScrollContainer = this.mListContainer.findListScrollContainer();

    this.mNoInjuredLabel = $('<div class="is-no-wounded-hint text-font-medium font-bottom-shadow font-color-description display-none">Vous n\'avez personne dans vos rangs qui puisse être entraîner ici.</div>');
    listContainerLayout.append(this.mNoInjuredLabel);

	// right column
    column = $('<div class="column is-right"/>');
    content.append(column);

	// details container
    var detailsFrame = $('<div class="l-details-frame"/>');
    column.append(detailsFrame);
    this.mDetailsPanel.Container = $('<div class="details-container display-none"/>');
    detailsFrame.append(this.mDetailsPanel.Container);

	// details: character container
    var detailsRow = $('<div class="row is-character-container"/>');
    this.mDetailsPanel.Container.append(detailsRow);
    var detailsColumn = $('<div class="column is-character-portrait-container"/>');
    detailsRow.append(detailsColumn);
    this.mDetailsPanel.CharacterImage = detailsColumn.createImage(null, function (_image)
    {
    	var offsetX = 0;
    	var offsetY = 0;

    	if (self.mSelectedEntry !== null)
    	{
    		var data = self.mSelectedEntry.data('entry');
    		if ('ImageOffsetX' in data && data['ImageOffsetX'] !== null &&
                'ImageOffsetY' in data && data['ImageOffsetY'] !== null)
    		{
    			offsetX = data['ImageOffsetX'];
    			offsetY = data['ImageOffsetY'];
    		}
    	}

    	_image.centerImageWithinParent(offsetX, offsetY, 1.0, false);
    	_image.removeClass('opacity-none');
    }, null, 'opacity-none');

    //var explanation = $('<div class="text-font-medium font-bottom-shadow font-color-description is-explanation">Training with and learning from experienced fighters will allow your men to develop faster into hardened mercenaries.</div>');
    var explanation = $('<div class="text-font-medium font-bottom-shadow font-color-description is-explanation">Louer le terrain d\'entraitement et payer pour des leçons pour façonner vos hommes en des guerriers aguerris.</div>');
    detailsRow.append(explanation);

    detailsColumn = $('<div class="column is-character-background-container"/>');
    detailsRow.append(detailsColumn);

	// details: background
    var backgroundRow = $('<div class="row is-top"/>');
    detailsColumn.append(backgroundRow);
    var backgroundRowBorder = $('<div class="row is-top border"/>');
    backgroundRow.append(backgroundRowBorder);

    this.mDetailsPanel.CharacterName = $('<div class="name title-font-normal font-bold font-color-brother-name"/>');
    backgroundRow.append(this.mDetailsPanel.CharacterName);
    backgroundRow = $('<div class="row is-bottom"/>');
    detailsColumn.append(backgroundRow);

    this.mDetailsPanel.ScrollContainer = backgroundRow.createList(10, 'is-injury-list', true);
    this.mDetailsPanel.ScrollContainerList = this.mDetailsPanel.ScrollContainer.findListScrollContainer();

	// create footer button bar
    var footerButtonBar = $('<div class="l-button-bar"/>');
    this.mDialogContainer.findDialogFooterContainer().append(footerButtonBar);

	// create: buttons
    var layout = $('<div class="l-leave-button"/>');
    footerButtonBar.append(layout);
    this.mLeaveButton = layout.createTextButton("Quitter", function ()
    {
    	self.notifyBackendLeaveButtonPressed();
    }, '', 1);

    this.mIsVisible = false;
};

WorldTownScreenTrainingDialogModule.prototype.destroyDIV = function ()
{
	this.mAssets.destroyDIV();

	this.mSelectedEntry = null;

    this.mDetailsPanel.CharacterName.empty();
    this.mDetailsPanel.CharacterName.remove();
    this.mDetailsPanel.CharacterName = null;

    this.mDetailsPanel.CharacterImage.empty();
    this.mDetailsPanel.CharacterImage.remove();
    this.mDetailsPanel.CharacterImage = null;

    this.mDetailsPanel.Container.empty();
    this.mDetailsPanel.Container.remove();
    this.mDetailsPanel.Container = null;

    this.mListScrollContainer.empty();
    this.mListScrollContainer = null;
    this.mListContainer.destroyList();
    this.mListContainer.remove();
    this.mListContainer = null;

	this.mLeaveButton.remove();
    this.mLeaveButton = null;

    this.mDialogContainer.empty();
    this.mDialogContainer.remove();
    this.mDialogContainer = null;

    this.mContainer.empty();
    this.mContainer.remove();
    this.mContainer = null;
};

WorldTownScreenTrainingDialogModule.prototype.addListEntry = function (_data)
{
    var result = $('<div class="l-row"/>');
    this.mListScrollContainer.append(result);

    var entry = $('<div class="ui-control list-entry"/>');
    result.append(entry);
    entry.data('entry', _data);
    entry.click(this, function(_event)
	{
        var self = _event.data;
        self.selectListEntry($(this));
    });

    // left column
    var column = $('<div class="column is-left"/>');
    entry.append(column);

    var imageOffsetX = ('ImageOffsetX' in _data ? _data['ImageOffsetX'] : 0);
    var imageOffsetY = ('ImageOffsetY' in _data ? _data['ImageOffsetY'] : 0);
    column.createImage(Path.PROCEDURAL + _data['ImagePath'], function (_image)
	{
        _image.centerImageWithinParent(imageOffsetX, imageOffsetY, 0.64, false);
        _image.removeClass('opacity-none');
    }, null, 'opacity-none');

    // right column
    column = $('<div class="column is-right"/>');
    entry.append(column);

    // top row
    var row = $('<div class="row is-top"/>');
    column.append(row);

    var image = $('<img/>');
    image.attr('src', Path.GFX + _data['BackgroundImagePath']);
    row.append(image);

    // bind tooltip
    image.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.CharacterBackgrounds.Generic, elementOwner: TooltipIdentifier.ElementOwner.HireScreen, entityId: _data.ID });

    var name = $('<div class="name title-font-normal font-bold font-color-brother-name">' + _data.Name + '</div>');
    row.append(name);

	// bind tooltip
	var levelContainer = $('<div class="l-level-container"/>');
    row.append(levelContainer);
    image = $('<img/>');
    image.attr('src', Path.GFX + Asset.ICON_LEVEL);
    levelContainer.append(image);
    var level = $('<div class="level text-font-normal font-bold font-color-subtitle">' + _data.Level + '</div>');
    levelContainer.append(level);

	// bottom row
    row = $('<div class="row is-bottom"/>');
    entry.data('bottom', row);
    column.append(row);

    for (var i = 0; i < _data.Effects.length; ++i)
    {
    	var icon = $('<img src="' + Path.GFX + _data.Effects[i].icon + '"/>');
    	icon.bindTooltip({ contentType: 'status-effect', entityId: _data.ID, statusEffectId: _data.Effects[i].id });
    	row.append(icon);
    }
};


WorldTownScreenTrainingDialogModule.prototype.updateSelectedListEntry = function (_data)
{
	if (this.mSelectedEntry == null)
		return;

	this.mSelectedEntry.data('entry', _data);

	// portrait
	var result = this.mSelectedEntry.find('img:first');
	if (result.length > 0)
	{
		result.attr('src', Path.PROCEDURAL + _data['ImagePath']);
	}

	// injuries
	var row = this.mSelectedEntry.data('bottom');
	row.empty();

	for (var i = 0; i < _data.Effects.length; ++i)
	{
		var icon = $('<img src="' + Path.GFX + _data.Effects[i].icon + '"/>');
		icon.bindTooltip({ contentType: 'status-effect', entityId: _data.ID, statusEffectId: _data.Effects[i].id });
		row.append(icon);
	}
};

WorldTownScreenTrainingDialogModule.prototype.selectListEntry = function(_element, _scrollToEntry)
{
    if (_element !== null && _element.length > 0)
    {
        // check if this is already selected
        //if (_element.hasClass('is-selected') !== true)
        {
            this.mListContainer.deselectListEntries();
            _element.addClass('is-selected');

            // give the renderer some time to layout his shit...
            if (_scrollToEntry !== undefined && _scrollToEntry === true)
            {
                this.mListContainer.scrollListToElement(_element);
            }

            this.mSelectedEntry = _element;
            this.updateDetailsPanel(this.mSelectedEntry);
        }
    }
    else
    {
        this.mSelectedEntry = null;
        this.updateDetailsPanel(this.mSelectedEntry);
    }
};

WorldTownScreenTrainingDialogModule.prototype.removeRosterEntry = function (_entry)
{
	if (_entry !== null)
	{
		var data = _entry.data('entry');
		if ('ID' in data && data['ID'] !== null && _data.item['ID'] === data['ID'])
		{
			entry = _entry.parent(); // get the 'l-row' container
			var prevEntry = _entry.prev();
			_entry.remove();

			if (prevEntry.length > 0)
			{
				this.selectListEntry(prevEntry.find('.list-entry:first'), false/*true*/);
			}
			else
			{
				this.selectListEntry(this.mListContainer.findListEntryByIndex(0), true);
			}

			this.mRoster.splice(_data.index, 1);
		}
		else
		{
			console.error('ERROR: Failed to update training roster. Invalid entry data.');
		}
	}
};

WorldTownScreenTrainingDialogModule.prototype.updateDetailsPanel = function(_element)
{
    if(_element !== null && _element.length > 0)
    {
        var currentMoney = this.mAssets.getValues().Money;
        var data = _element.data('entry');
        
		this.mDetailsPanel.CharacterImage.attr('src', Path.PROCEDURAL + data.ImagePath);     
        this.mDetailsPanel.CharacterImage.centerImageWithinParent(0, 0, 1.0); 
           
        this.mDetailsPanel.CharacterName.html(data['Name']);

        this.mDetailsPanel.ScrollContainerList.empty();

        if(data.Training.length != 0)
        {
        	for (var i = 0; i < data.Training.length; ++i)
        	{
        		this.createTrainingControlDIV(i, this.mDetailsPanel.ScrollContainerList, data.ID, data.Training[i], currentMoney);
        	}
        }
        else
        {
        	var row = $('<div class="is-injury-row display-block text-font-medium font-bottom-shadow font-color-description display-none">No training options available at this time.</div>');
        	this.mDetailsPanel.ScrollContainerList.append(row);
        }

        this.mDetailsPanel.Container.removeClass('display-none').addClass('display-block');
    }
    else
    {
        this.mDetailsPanel.Container.removeClass('display-block').addClass('display-none');
    }
};

WorldTownScreenTrainingDialogModule.prototype.createTrainingControlDIV = function (_i, _parentDiv, _entityID, _data, _money)
{
	var self = this;

	var row = $('<div class="is-injury-row display-block"/>');
	row.css({ 'top': ((7.5*_i) + 'rem') });
	_parentDiv.append(row);

	var icon = $('<img class="is-icon"/>');
	icon.attr('src', Path.GFX + _data.icon);
	icon.bindTooltip({ contentType: 'ui-element', elementId: _data.tooltip });
	//icon.bindTooltip({ contentType: 'status-effect', entityId: _entityID, statusEffectId: _data.id });
	row.append(icon);

	var name = $('<div class="is-name text-font-normal font-bottom-shadow font-color-description">' + _data.name + '</div>');
	name.bindTooltip({ contentType: 'ui-element', elementId: _data.tooltip });
	row.append(name);

	var layout = $('<div class="is-button"/>');
	row.append(layout);

	var price;
	if (_data.price > _money)
		price = $('<div class="is-price"><div class="is-price-ffs font-color-assets-negative-value"><img src="' + Path.GFX + Asset.ICON_MONEY_SMALL + '"/> ' + Helper.numberWithCommas(_data.price) + '</div></div>');
	else
		price = $('<div class="is-price"><div class="is-price-ffs"><img src="' + Path.GFX + Asset.ICON_MONEY_SMALL + '"/> ' + Helper.numberWithCommas(_data.price) + '</div></div>');

	var button = layout.createCustomButton(price, function ()
	{
		self.notifyBackendTrain(_entityID, _data.id, function (_result)
		{
			self.mAssets.loadFromData(_result.Assets);
			self.updateSelectedListEntry(_result.Entity);
			self.updateDetailsPanel(self.mSelectedEntry);
		});
	}, '', 1);

	if (_data.price > _money)
		button.enableButton(false);
};

WorldTownScreenTrainingDialogModule.prototype.bindTooltips = function ()
{
    this.mAssets.bindTooltips();
    this.mLeaveButton.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.WorldTownScreen.HireDialogModule.LeaveButton });
};

WorldTownScreenTrainingDialogModule.prototype.unbindTooltips = function ()
{
	this.mAssets.unbindTooltips();
    this.mLeaveButton.unbindTooltip();
};


WorldTownScreenTrainingDialogModule.prototype.create = function(_parentDiv)
{
    this.createDIV(_parentDiv);
    this.bindTooltips();
};

WorldTownScreenTrainingDialogModule.prototype.destroy = function()
{
    this.unbindTooltips();
    this.destroyDIV();
};


WorldTownScreenTrainingDialogModule.prototype.register = function (_parentDiv)
{
    console.log('WorldTownScreenTrainingDialogModule::REGISTER');

    if (this.mContainer !== null)
    {
        console.error('ERROR: Failed to register World Town Screen Temple Dialog Module. Reason: Module is already initialized.');
        return;
    }

    if (_parentDiv !== null && typeof(_parentDiv) == 'object')
    {
        this.create(_parentDiv);
    }
};

WorldTownScreenTrainingDialogModule.prototype.unregister = function ()
{
    console.log('WorldTownScreenTrainingDialogModule::UNREGISTER');

    if (this.mContainer === null)
    {
        console.error('ERROR: Failed to unregister World Town Screen Temple Dialog Module. Reason: Module is not initialized.');
        return;
    }

    this.destroy();
};

WorldTownScreenTrainingDialogModule.prototype.isRegistered = function ()
{
    if (this.mContainer !== null)
    {
        return this.mContainer.parent().length !== 0;
    }

    return false;
};


WorldTownScreenTrainingDialogModule.prototype.registerEventListener = function(_listener)
{
    this.mEventListener = _listener;
};


WorldTownScreenTrainingDialogModule.prototype.show = function (_withSlideAnimation)
{
    var self = this;

    var withAnimation = (_withSlideAnimation !== undefined && _withSlideAnimation !== null) ? _withSlideAnimation : true;
    if (withAnimation === true)
    {
        var offset = -(this.mContainer.parent().width() + this.mContainer.width());
        this.mContainer.css({ 'left': offset });
        this.mContainer.velocity("finish", true).velocity({ opacity: 1, left: '0', right: '0' }, {
            duration: Constants.SCREEN_SLIDE_IN_OUT_DELAY,
            easing: 'swing',
            begin: function () {
                $(this).removeClass('display-none').addClass('display-block');
                self.notifyBackendModuleAnimating();
            },
            complete: function () {
                self.mIsVisible = true;
                self.notifyBackendModuleShown();
            }
        });
    }
    else
    {
        this.mContainer.css({ opacity: 0 });
        this.mContainer.velocity("finish", true).velocity({ opacity: 1 }, {
            duration: Constants.SCREEN_FADE_IN_OUT_DELAY,
            easing: 'swing',
            begin: function() {
                $(this).removeClass('display-none').addClass('display-block');
                self.notifyBackendModuleAnimating();
            },
            complete: function() {
                self.mIsVisible = true;
                self.notifyBackendModuleShown();
            }
        });
    }
};

WorldTownScreenTrainingDialogModule.prototype.hide = function ()
{
    var self = this;

    var offset = -(this.mContainer.parent().width() + this.mContainer.width());
    this.mContainer.velocity("finish", true).velocity({ opacity: 0, left: offset },
	{
        duration: Constants.SCREEN_SLIDE_IN_OUT_DELAY,
        easing: 'swing',
        begin: function ()
        {
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

WorldTownScreenTrainingDialogModule.prototype.isVisible = function ()
{
    return this.mIsVisible;
};

WorldTownScreenTrainingDialogModule.prototype.updateAssets = function (_data)
{
	this.mAssets.loadFromData(_data);
	//this.updateListEntryValues();
}

WorldTownScreenTrainingDialogModule.prototype.loadFromData = function (_data)
{
	if(_data === undefined || _data === null)
    {
        return;
    }

	if('Title' in _data && _data.Title !== null)
	{
		 this.mDialogContainer.findDialogTitle().html(_data.Title);
	}

	if('SubTitle' in _data && _data.SubTitle !== null)
	{
		 this.mDialogContainer.findDialogSubTitle().html(_data.SubTitle);
	}

	this.mRoster = _data.Roster;

    this.mListScrollContainer.empty();

    if (_data.Roster.length != 0)
    {
    	this.mNoInjuredLabel.addClass('display-none');

    	for (var i = 0; i < _data.Roster.length; ++i)
    	{
    		var entry = _data.Roster[i];
    		this.addListEntry(entry);
    	}
    }
    else
    {
    	this.mNoInjuredLabel.removeClass('display-none');
    }

    this.selectListEntry(this.mListContainer.findListEntryByIndex(0), true);
};

WorldTownScreenTrainingDialogModule.prototype.changeRosterEntry = function (_entryID)
{
    var self = this;
    this.notifyBackendChangeAppearance(_entryID, function(imagePath)
    {
    	var result = self.mSelectedEntry.find('img:first');
        if(result.length > 0)
        {
           result.attr('src', Path.PROCEDURAL + imagePath);
        }
    });
};

WorldTownScreenTrainingDialogModule.prototype.notifyBackendModuleShown = function ()
{
    SQ.call(this.mSQHandle, 'onModuleShown');
};

WorldTownScreenTrainingDialogModule.prototype.notifyBackendModuleHidden = function ()
{
    SQ.call(this.mSQHandle, 'onModuleHidden');
};

WorldTownScreenTrainingDialogModule.prototype.notifyBackendModuleAnimating = function ()
{
    SQ.call(this.mSQHandle, 'onModuleAnimating');
};

WorldTownScreenTrainingDialogModule.prototype.notifyBackendLeaveButtonPressed = function ()
{
	SQ.call(this.mSQHandle, 'onLeaveButtonPressed');
};

WorldTownScreenTrainingDialogModule.prototype.notifyBackendBrothersButtonPressed = function ()
{
    SQ.call(this.mSQHandle, 'onBrothersButtonPressed');
};

WorldTownScreenTrainingDialogModule.prototype.notifyBackendTrain = function (_entityID, _trainingID, _callback)
{
    SQ.call(this.mSQHandle, 'onTrain', [ _entityID, _trainingID ], _callback);
};

"use strict";

var WorldTownScreenTaxidermistDialogModule = function(_parent)
{
	this.mSQHandle = null;
    this.mParent = _parent;

	this.mBlueprints = null;

    // event listener
    this.mEventListener = null;

	// generic containers
	this.mContainer = null;
    this.mDialogContainer = null;
    this.mListContainer = null;
    this.mListScrollContainer = null;
    this.mNoCraftablesLabel = null;

    this.mDetailsPanel =
    {
        Container: null,
        CharacterImage: null,
        CharacterName: null,
        DescriptionTextContainer: null,
        ScrollContainerList: null,
        Components: null,
        Cost: null,
        CraftButton: null
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


WorldTownScreenTaxidermistDialogModule.prototype.isConnected = function ()
{
    return this.mSQHandle !== null;
};

WorldTownScreenTaxidermistDialogModule.prototype.onConnection = function (_handle)
{
	this.mSQHandle = _handle;

    // notify listener
    if (this.mEventListener !== null && ('onModuleOnConnectionCalled' in this.mEventListener))
	{
        this.mEventListener.onModuleOnConnectionCalled(this);
    }
};

WorldTownScreenTaxidermistDialogModule.prototype.onDisconnection = function ()
{
	this.mSQHandle = null;

    // notify listener
    if (this.mEventListener !== null && ('onModuleOnDisconnectionCalled' in this.mEventListener))
	{
        this.mEventListener.onModuleOnDisconnectionCalled(this);
    }
};

WorldTownScreenTaxidermistDialogModule.prototype.createDIV = function (_parentDiv)
{
    var self = this;

    // create: containers (init hidden!)
    this.mContainer = $('<div class="l-taxidermist-dialog-container display-none opacity-none"/>');
    _parentDiv.append(this.mContainer);
    this.mDialogContainer = this.mContainer.createDialog('Taxidermist', '', '', true, 'dialog-1024-768');

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

    this.mNoCraftablesLabel = $('<div class="is-no-craftables-hint text-font-medium font-bottom-shadow font-color-description display-none">Rien ne peut être fabriqué avec les trophés que vous avez en votre possession.</div>');
    listContainerLayout.append(this.mNoCraftablesLabel);

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

        _image.centerImageWithinParent(offsetX, offsetY, 1.0);
        _image.removeClass('opacity-none');
    }, null, 'opacity-none');
    detailsColumn = $('<div class="column is-character-background-container"/>');
    detailsRow.append(detailsColumn);

    // details: background
    var backgroundRow = $('<div class="row is-top"/>');
    detailsColumn.append(backgroundRow);
    var backgroundRowBorder = $('<div class="row is-top border"/>');
    backgroundRow.append(backgroundRowBorder);

    /*this.mDetailsPanel.CharacterBackgroundImage = $('<img />');
    detailsColumn.append(this.mDetailsPanel.CharacterBackgroundImage);*/
    this.mDetailsPanel.CharacterName = $('<div class="name title-font-normal font-bold font-color-brother-name"/>');
    backgroundRow.append(this.mDetailsPanel.CharacterName);
    backgroundRow = $('<div class="row is-bottom"/>');
    detailsColumn.append(backgroundRow);
    this.mDetailsPanel.DescriptionTextContainer = backgroundRow.createList(20, 'description-font-medium font-bottom-shadow font-color-description', true);
    this.mDetailsPanel.ScrollContainerList = this.mDetailsPanel.DescriptionTextContainer.findListScrollContainer();

    // details: ingredients
    detailsRow = $('<div class="row is-ingredients-container"/>');
    this.mDetailsPanel.Container.append(detailsRow);
    var ingredientsHeader = $('<div class="row is-header"/>');
    detailsRow.append(ingredientsHeader);
    var ingredientsHeaderLabel = $('<div class="label title-font-normal font-bold font-bottom-shadow font-color-title">Composants requis</div>');
    ingredientsHeader.append(ingredientsHeaderLabel);

    this.mDetailsPanel.Components = $('<div class="row is-components-container"/>');
    detailsRow.append(this.mDetailsPanel.Components);

    // details: costs
    detailsRow = $('<div class="row is-costs-container"/>');
    this.mDetailsPanel.Container.append(detailsRow);
    var costsHeader = $('<div class="row is-header"/>');
    detailsRow.append(costsHeader);
    var costsHeaderLabel = $('<div class="label title-font-normal font-bold font-bottom-shadow font-color-title">Prix</div>');
    costsHeader.append(costsHeaderLabel);
    var costsInitial = $('<div class="row is-initial-costs"/>');
    detailsRow.append(costsInitial);
    var costsLabel = $('<div class="costs-label title-font-normal font-bold font-bottom-shadow font-color-title">Paiement Direct</div>');
    costsInitial.append(costsLabel);
    var costsContainer = $('<div class="l-costs-container"/>');
    costsInitial.append(costsContainer);
    var costsImage = $('<img/>');
    costsImage.attr('src', Path.GFX + Asset.ICON_ASSET_MONEY);
    costsContainer.append(costsImage);
    costsImage.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.Assets.Fee });
    this.mDetailsPanel.Cost = $('<div class="label text-font-normal font-bottom-shadow font-color-description"/>');
    costsContainer.append(this.mDetailsPanel.Cost);

    // details: buttons
    detailsRow = $('<div class="row is-button-container"/>');
    this.mDetailsPanel.Container.append(detailsRow);
    var craftButtonLayout = $('<div class="l-hire-button"/>');
    detailsRow.append(craftButtonLayout);
    this.mDetailsPanel.CraftButton = craftButtonLayout.createTextButton("Fabriquer", function ()
    {
        if (self.mSelectedEntry !== null)
        {
            var data = self.mSelectedEntry.data('entry');
            if ('ID' in data && data['ID'] !== null)
            {
                self.notifyBackendCraft(data['ID'], function (_result)
                {
                    self.mAssets.loadFromData(_result.Assets);

                    if (_result != null)
                    {
                        self.loadFromData(_result);
                        self.updateDetailsPanel(self.mSelectedEntry);
                    }
                });
            }
        }
    }, '', 1);

	// create footer button bar
    var footerButtonBar = $('<div class="l-button-bar"/>');
    this.mDialogContainer.findDialogFooterContainer().append(footerButtonBar);

	// create: buttons
    var layout = $('<div class="l-leave-button"/>');
    footerButtonBar.append(layout);
    this.mLeaveButton = layout.createTextButton("Partir", function ()
    {
    	self.notifyBackendLeaveButtonPressed();
    }, '', 1);

    this.mIsVisible = false;
};

WorldTownScreenTaxidermistDialogModule.prototype.destroyDIV = function ()
{
	this.mAssets.destroyDIV();

	this.mSelectedEntry = null;

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

WorldTownScreenTaxidermistDialogModule.prototype.addListEntry = function (_data)
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

    if(!_data.IsCraftable)
        entry.addClass('is-disabled');

    // left column
    var column = $('<div class="column is-left"/>');
    entry.append(column);

    var imageOffsetX = ('ImageOffsetX' in _data ? _data['ImageOffsetX'] : 0);
    var imageOffsetY = ('ImageOffsetY' in _data ? _data['ImageOffsetY'] : 0);
    var image = column.createImage(Path.ITEMS + _data['ImagePath'], function (_image)
	{
        _image.centerImageWithinParent(imageOffsetX, imageOffsetY, 0.64, false);
        _image.removeClass('opacity-none');
    }, null, 'opacity-none');
    image.bindTooltip({ contentType: 'ui-item', itemId: _data.ID, itemOwner: 'craft' });

    // right column
    column = $('<div class="column is-right"/>');
    entry.append(column);

    // top row
    var row = $('<div class="row is-top"/>');
    column.append(row);

    // bind tooltip
    //image.bindTooltip({ contentType: 'ui-item', itemId: _data.InstanceID, itemOwner: TooltipIdentifier.ItemOwner.Stash });

    if(_data.IsCraftable)
    {
        var name = $('<div class="name title-font-normal font-bold font-color-brother-name">' + _data.Name + '</div>');
        row.append(name);
    }
    else
    {
        var name = $('<div class="name title-font-normal font-bold font-color-disabled">' + _data.Name + '</div>');
        row.append(name);
    }

	// bottom row
    row = $('<div class="row is-bottom"/>');
    entry.data('bottom', row);
    column.append(row);

    for(var i = 0; i < _data.Ingredients.length; ++i)
    {
        var iconContainer = $('<div class="icons-container"/>');
        row.append(iconContainer);

        var icon = $('<img src="' + Path.ITEMS + _data.Ingredients[i].ImagePath + '"/>');
        icon.bindTooltip({ contentType: 'ui-item', itemId: _data.Ingredients[i].InstanceID, entityId: _data.ID, itemOwner: 'blueprint' });
        iconContainer.append(icon);

        if(_data.Ingredients[i].IsMissing)
        {
            icon.css({ '-webkit-filter': 'brightness(60%)' });
            var overlay = $('<img src="' + Path.ITEMS + 'missing_component.png" class="component-overlay" />');
            iconContainer.append(overlay);
        }        
    }
};

WorldTownScreenTaxidermistDialogModule.prototype.selectListEntry = function(_element, _scrollToEntry)
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

WorldTownScreenTaxidermistDialogModule.prototype.updateDetailsPanel = function(_element)
{
    if(_element !== null && _element.length > 0)
    {
        var currentMoney = this.mAssets.getValues().Money;
        var data = _element.data('entry');
        
        this.mDetailsPanel.CharacterImage.attr('src', Path.ITEMS + data.LargeImagePath);     
        this.mDetailsPanel.CharacterImage.centerImageWithinParent(0, 0, 1.0); 
        this.mDetailsPanel.CharacterImage.bindTooltip({ contentType: 'ui-item', itemId: data.ID, itemOwner: 'craft' });

        this.mDetailsPanel.CharacterName.html(data['Name']);
        this.mDetailsPanel.DescriptionTextContainer.html(data['Description']);

        this.mDetailsPanel.Components.empty();
        for(var i = 0; i < data.Ingredients.length; ++i)
        {
            var iconContainer = $('<div class="icons-container"/>');
            this.mDetailsPanel.Components.append(iconContainer);

            var icon = $('<img src="' + Path.ITEMS + data.Ingredients[i].ImagePath + '"/>');
            icon.bindTooltip({ contentType: 'ui-item', itemId: data.Ingredients[i].InstanceID, entityId: data.ID, itemOwner: 'blueprint' });
            iconContainer.append(icon);

            if(data.Ingredients[i].IsMissing)
            {
                icon.css({ '-webkit-filter': 'brightness(60%)' });
                var overlay = $('<img src="' + Path.ITEMS + 'missing_component.png" class="component-overlay" />');
                iconContainer.append(overlay);
            }            
        }

        this.mDetailsPanel.Container.removeClass('display-none').addClass('display-block');

        this.mDetailsPanel.Cost.html(Helper.numberWithCommas(data['Cost']));
        if(currentMoney < data['Cost'])
        {
            this.mDetailsPanel.Cost.removeClass('font-color-description').addClass('font-color-assets-negative-value');           
        }
        else
        {
            this.mDetailsPanel.Cost.removeClass('font-color-assets-negative-value').addClass('font-color-description');
        }

        if(currentMoney < data['Cost'] || !data['IsCraftable'])
        {
            this.mDetailsPanel.CraftButton.enableButton(false);
        }
        else
        {
            this.mDetailsPanel.CraftButton.enableButton(true);
        }
    }
    else
    {
        this.mDetailsPanel.Container.removeClass('display-block').addClass('display-none');
    }
};


WorldTownScreenTaxidermistDialogModule.prototype.bindTooltips = function ()
{
    this.mAssets.bindTooltips();
    this.mDetailsPanel.CraftButton.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.WorldTownScreen.TaxiDermistDialogModule.CraftButton });
    this.mLeaveButton.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.WorldTownScreen.HireDialogModule.LeaveButton });
};

WorldTownScreenTaxidermistDialogModule.prototype.unbindTooltips = function ()
{
	this.mAssets.unbindTooltips();
    this.mDetailsPanel.CraftButton.unbindTooltip();
    this.mLeaveButton.unbindTooltip();
};


WorldTownScreenTaxidermistDialogModule.prototype.create = function(_parentDiv)
{
    this.createDIV(_parentDiv);
    this.bindTooltips();
};

WorldTownScreenTaxidermistDialogModule.prototype.destroy = function()
{
    this.unbindTooltips();
    this.destroyDIV();
};


WorldTownScreenTaxidermistDialogModule.prototype.register = function (_parentDiv)
{
    console.log('WorldTownScreenTaxidermistDialogModule::REGISTER');

    if (this.mContainer !== null)
    {
        console.error('ERROR: Failed to register World Town Screen Taxidermist Dialog Module. Reason: Module is already initialized.');
        return;
    }

    if (_parentDiv !== null && typeof(_parentDiv) == 'object')
    {
        this.create(_parentDiv);
    }
};

WorldTownScreenTaxidermistDialogModule.prototype.unregister = function ()
{
    console.log('WorldTownScreenTaxidermistDialogModule::UNREGISTER');

    if (this.mContainer === null)
    {
        console.error('ERROR: Failed to unregister World Town Screen Taxidermist Dialog Module. Reason: Module is not initialized.');
        return;
    }

    this.destroy();
};

WorldTownScreenTaxidermistDialogModule.prototype.isRegistered = function ()
{
    if (this.mContainer !== null)
    {
        return this.mContainer.parent().length !== 0;
    }

    return false;
};


WorldTownScreenTaxidermistDialogModule.prototype.registerEventListener = function(_listener)
{
    this.mEventListener = _listener;
};


WorldTownScreenTaxidermistDialogModule.prototype.show = function (_withSlideAnimation)
{
    var self = this;

    var withAnimation = (_withSlideAnimation !== undefined && _withSlideAnimation !== null) ? _withSlideAnimation : true;
    if (withAnimation === true)
    {
        var offset = -(this.mContainer.parent().width() + this.mContainer.width());
        this.mContainer.css({ 'left': offset });
        this.mContainer.velocity("finish", true).velocity({ opacity: 1, left: '0', right: '0' },
        {
            duration: Constants.SCREEN_SLIDE_IN_OUT_DELAY,
            easing: 'swing',
            begin: function ()
            {
                $(this).removeClass('display-none').addClass('display-block');
                self.notifyBackendModuleAnimating();
            },
            complete: function ()
            {
                self.mIsVisible = true;
                self.notifyBackendModuleShown();
            }
        });
    }
    else
    {
        this.mContainer.css({ opacity: 0 });
        this.mContainer.velocity("finish", true).velocity({ opacity: 1 },
        {
            duration: Constants.SCREEN_FADE_IN_OUT_DELAY,
            easing: 'swing',
            begin: function ()
            {
                $(this).removeClass('display-none').addClass('display-block');
                self.notifyBackendModuleAnimating();
            },
            complete: function ()
            {
                self.mIsVisible = true;
                self.notifyBackendModuleShown();
            }
        });
    }
};

WorldTownScreenTaxidermistDialogModule.prototype.hide = function ()
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

WorldTownScreenTaxidermistDialogModule.prototype.isVisible = function ()
{
    return this.mIsVisible;
};

WorldTownScreenTaxidermistDialogModule.prototype.updateAssets = function (_data)
{
	this.mAssets.loadFromData(_data);
	//this.updateListEntryValues();
}

WorldTownScreenTaxidermistDialogModule.prototype.loadFromData = function (_data)
{
    if(_data === undefined || _data === null || _data.Blueprints == null)
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

	this.mBlueprints = _data.Blueprints;

    this.mListScrollContainer.empty();

    if (_data.Blueprints.length != 0)
    {
    	this.mNoCraftablesLabel.addClass('display-none');

        for (var i = 0; i < _data.Blueprints.length; ++i)
    	{
            this.addListEntry(_data.Blueprints[i]);
    	}
    }
    else
    {
    	this.mNoCraftablesLabel.removeClass('display-none');
    }

    this.selectListEntry(this.mListContainer.findListEntryByIndex(0), true);
};


WorldTownScreenTaxidermistDialogModule.prototype.notifyBackendModuleShown = function ()
{
    SQ.call(this.mSQHandle, 'onModuleShown');
};

WorldTownScreenTaxidermistDialogModule.prototype.notifyBackendModuleHidden = function ()
{
    SQ.call(this.mSQHandle, 'onModuleHidden');
};

WorldTownScreenTaxidermistDialogModule.prototype.notifyBackendModuleAnimating = function ()
{
    SQ.call(this.mSQHandle, 'onModuleAnimating');
};

WorldTownScreenTaxidermistDialogModule.prototype.notifyBackendLeaveButtonPressed = function ()
{
	SQ.call(this.mSQHandle, 'onLeaveButtonPressed');
};

WorldTownScreenTaxidermistDialogModule.prototype.notifyBackendBrothersButtonPressed = function ()
{
    SQ.call(this.mSQHandle, 'onBrothersButtonPressed');
};

WorldTownScreenTaxidermistDialogModule.prototype.notifyBackendCraft = function (_blueprintID, _callback)
{
    SQ.call(this.mSQHandle, 'onCraft', _blueprintID, _callback);
};
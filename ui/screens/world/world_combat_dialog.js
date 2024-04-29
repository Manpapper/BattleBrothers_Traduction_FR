/*
 *  @Project:		Battle Brothers
 *	@Company:		Overhype Studios
 *
 *	@Copyright:		(c) Overhype Studios | 2013 - 2020
 * 
 *  @Author:		Overhype Studios
 *  @Date:			08.10.2017
 *  @Description:	Conbat Dialog Module JS
 */
"use strict";

var WorldCombatDialog = function()
{
	this.mSQHandle = null;

    // event listener
    this.mEventListener = null;

	// generic containers
	this.mContainer = null;
    this.mDialogContainer = null;

    // generics
    this.mIsVisible = false;
};


WorldCombatDialog.prototype.isConnected = function ()
{
    return this.mSQHandle !== null;
};

WorldCombatDialog.prototype.onConnection = function (_handle)
{
    this.mSQHandle = _handle;
    this.register($('.root-screen'));
};

WorldCombatDialog.prototype.onDisconnection = function ()
{
    this.mSQHandle = null;
    this.unregister();
};

WorldCombatDialog.prototype.register = function (_parentDiv)
{
    console.log('WorldCombatDialog::REGISTER');

    if (this.mContainer !== null)
    {
        console.error('ERROR: Failed to register World Combat Dialog. Reason: Already initialized.');
        return;
    }

    if (_parentDiv !== null && typeof (_parentDiv) == 'object')
    {
        this.create(_parentDiv);
    }
};

WorldCombatDialog.prototype.unregister = function ()
{
    console.log('WorldCombatDialog::UNREGISTER');

    if (this.mContainer === null)
    {
        console.error('ERROR: Failed to unregister World Combat Dialog. Reason: Not initialized.');
        return;
    }

    this.destroy();
};


WorldCombatDialog.prototype.createDIV = function (_parentDiv)
{
    var self = this;

    // create: containers (init hidden!)
    this.mContainer = $('<div class="world-combat-dialog ui-control dialog-modal-background display-none"></div>');
    _parentDiv.append(this.mContainer);

    this.mIsVisible = false;
};

WorldCombatDialog.prototype.loadFromData = function (_data)
{
	var allowDisengage = _data.AllowDisengage;
	var entities = _data.Entities;
	var self = this;

	// set dialog container
	if(this.mDialogContainer != null)
	{
		this.mDialogContainer.remove();
		this.mDialogContainer = null;
	}

    var dialogLayout = $('<div class="l-dialog-container"/>');
    this.mContainer.append(dialogLayout);
    this.mDialogContainer = dialogLayout.createDialog(allowDisengage ? 'Se préparer pour le combat' : 'Vous êtes attaqué', null, /*Path.GFX + Asset.HEADER_TACTICAL_COMBAT_DIALOG*/null, true, 'dialog-800-720-2');
  
	// create buttons
	this.createButtons(allowDisengage, _data.DisengageText);

	// set content
	this.mContentContainer = this.mDialogContainer.findDialogContentContainer();

	/*if (_data.Image !== null)
	{
	    var imageLayer = $('<div class="image-row"/>');
	    this.mContentContainer.append(imageLayer);
	    imageLayer.createImage(Path.GFX + 'ui/' + _data.Image, null, null, 'display-block terrain-image');
	}*/

    var rightColumn = $('<div class="right-column "/>');
    this.mContentContainer.append(rightColumn);
    
    if (_data.Image !== null)
    {
        rightColumn.createImage(Path.GFX + 'ui/' + _data.Image, null, null, 'display-block terrain-image');
    }

	if(entities.length == 0)
	{
		var titleLabel = $('<div class="title-empty-label text-font-medium font-color-subtitle">' + _data.Text + '</div>');
		rightColumn.append(titleLabel);
	}
	else
	{
		var titleLabel = $('<div class="title-label text-font-medium font-color-subtitle">Vos éclaireurs vous rapportent ce qu\'ils ont vu...</div>');
		rightColumn.append(titleLabel);

		var table = '<table class="entity-table" width="70%">';

		for(var i = 0; i < entities.length; ++i)
		{
			if(i > 6)
				break;

            table += '<tr><td width="10%"><div class="entity-div"><img src="' + Path.GFX + 'ui/orientation/' + entities[i]['Icon'] + '.png" />';

            if(entities[i]['Overlay'] != null)
                table += '<img src="' + Path.GFX + 'ui/' + entities[i]['Overlay'] + '" class="entity-overlay"/>';

            table += '</div></td > <td width="5%"/> <td width="85%" class="entity-label text-font-medium font-color-description">' + entities[i]['Name'] + '</td></tr >';	
		}

		table += '</table>';
		rightColumn.append($(table));
	}

	if(_data.AllyBanners.length != 0)
	{
		var allyBanners = $('<div class="ally-banners"/>');
		this.mContentContainer.append(allyBanners);

		for (var i = 0; i < _data.AllyBanners.length; ++i)
		{
			if (i >= 3)
				break;

			var img = $('<img src="' + Path.GFX + 'ui/banners/' + _data.AllyBanners[i] + '.png" class="banner"\>');
			allyBanners.append(img);
		}
	}

	if (_data.EnemyBanners.length != 0)
	{
		var enemyBanners = $('<div class="enemy-banners"/>');
		this.mContentContainer.append(enemyBanners);

		for (var i = 0; i < _data.EnemyBanners.length; ++i)
		{
			if (i >= 3)
				break;

			var img = $('<img src="' + Path.GFX + 'ui/banners/' + _data.EnemyBanners[i] + '.png" class="banner"\>');
			enemyBanners.append(img);
		}
	}
}

WorldCombatDialog.prototype.createButtons = function (_allowDisengage, _disengageText)
{
	// create footer button bar
    var footerButtonBar = $('<div class="l-button-bar"></div>');
    var footerContainer = this.mDialogContainer.findDialogFooterContainer();
	footerContainer.empty();
	footerContainer.append(footerButtonBar); 

	var self = this;

	if(_allowDisengage)
	{
		var layout = $('<div class="l-engage-button"/>');
		footerButtonBar.append(layout);
		layout.createTextButton("Engager !", function ()
		{
			self.notifyBackendEngageButtonPressed();
		}, '', 1);

		layout = $('<div class="l-cancel-button"/>');
		footerButtonBar.append(layout);
		layout.createTextButton(_disengageText, function ()
		{
			self.notifyBackendCancelButtonPressed();
		}, '', 1);
	}
	else
	{
		var layout = $('<div class="l-defend-button"/>');
		footerButtonBar.append(layout);
		layout.createTextButton("Aux Armes!", function ()
		{
			self.notifyBackendEngageButtonPressed();
		}, '', 1);
	}
}

WorldCombatDialog.prototype.destroyDIV = function ()
{
    if(this.mDialogContainer != null)
	{
		this.mDialogContainer.empty();
		this.mDialogContainer.remove();
		this.mDialogContainer = null;
	}

    this.mContainer.empty();
    this.mContainer.remove();
    this.mContainer = null;
};


WorldCombatDialog.prototype.bindTooltips = function ()
{
    /*
     this.mBrothersCountContainer.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.TacticalScreen.RoundInformationModule.BrothersCounter });
     */
};

WorldCombatDialog.prototype.unbindTooltips = function ()
{

};


WorldCombatDialog.prototype.create = function(_parentDiv)
{
    this.createDIV(_parentDiv);
    this.bindTooltips();
};

WorldCombatDialog.prototype.destroy = function()
{
    this.unbindTooltips();
    this.destroyDIV();
};


WorldCombatDialog.prototype.show = function (_data)
{
    var self = this;

	// build dialog
	this.loadFromData(_data);

	// animate
    this.mContainer.velocity("finish", true).velocity({ opacity: 1 },
	{
        duration: Constants.SCREEN_FADE_IN_OUT_DELAY,
        easing: 'swing',
		begin: function()
		{
            $(this).removeClass('display-none').addClass('display-block');
            self.notifyBackendOnAnimating();
        },
		complete: function()
		{
            self.mIsVisible = true;
            self.notifyBackendOnShown();
        }
    });
};

WorldCombatDialog.prototype.hide = function ()
{
    var self = this;

    this.mContainer.velocity("finish", true).velocity({ opacity: 0 },
	{
        duration: Constants.SCREEN_FADE_IN_OUT_DELAY,
        easing: 'swing',
		begin: function()
		{
		    self.notifyBackendOnAnimating();
        },
		complete: function()
		{
            self.mIsVisible = false;
            $(this).removeClass('display-block').addClass('display-none');
            self.notifyBackendOnHidden();
        }
    });
};

WorldCombatDialog.prototype.isVisible = function ()
{
    return this.mIsVisible;
};


WorldCombatDialog.prototype.notifyBackendOnShown = function ()
{
    if (this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onScreenShown');
    }
};

WorldCombatDialog.prototype.notifyBackendOnHidden = function ()
{
    if (this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onScreenHidden');
    }
};

WorldCombatDialog.prototype.notifyBackendOnAnimating = function ()
{
    if (this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onScreenAnimating');
    }
};

WorldCombatDialog.prototype.notifyBackendEngageButtonPressed = function ()
{
	if (this.mSQHandle !== null)
	{
		SQ.call(this.mSQHandle, 'onEngageButtonPressed');
	}
};

WorldCombatDialog.prototype.notifyBackendCancelButtonPressed = function ()
{
    if (this.mSQHandle !== null)
    {
        SQ.call(this.mSQHandle, 'onCancelButtonPressed');
    }
};
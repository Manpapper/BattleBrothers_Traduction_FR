this.fletcher_building <- this.inherit("scripts/entity/world/settlements/buildings/building", {
	m = {
		Stash = null
	},
	function getStash()
	{
		return this.m.Stash;
	}

	function create()
	{
		this.building.create();
		this.m.ID = "building.fletcher";
		this.m.Name = "Fletcher";
		this.m.Description = "All kinds of expertly crafted ranged weaponry can be found here";
		this.m.UIImage = "ui/settlements/building_11";
		this.m.UIImageNight = "ui/settlements/building_11_night";
		this.m.Tooltip = "world-town-screen.main-dialog-module.Fletcher";
		this.m.TooltipIcon = "ui/icons/buildings/fletcher.png";
		this.m.Stash = this.new("scripts/items/stash_container");
		this.m.Stash.setID("shop");
		this.m.Stash.setResizable(true);
		this.m.Sounds = [
			{
				File = "ambience/settlement/settlement_saw_00.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/settlement/settlement_saw_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/settlement/settlement_building_00.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/settlement/settlement_building_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/settlement/settlement_building_02.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/settlement/settlement_building_03.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/settlement/settlement_building_03.wav",
				Volume = 1.0,
				Pitch = 1.0
			}
		];
		this.m.SoundsAtNight = [];
	}

	function onClicked( _townScreen )
	{
		_townScreen.getShopDialogModule().setShop(this);
		_townScreen.showShopDialog();
		this.pushUIMenuStack();
	}

	function onSettlementEntered()
	{
		foreach( item in this.m.Stash.getItems() )
		{
			if (item != null)
			{
				item.setSold(false);
			}
		}
	}

	function onUpdateShopList()
	{
		local list = [
			{
				R = 10,
				P = 1.0,
				S = "weapons/short_bow"
			},
			{
				R = 10,
				P = 1.0,
				S = "weapons/short_bow"
			},
			{
				R = 10,
				P = 1.0,
				S = "weapons/hunting_bow"
			},
			{
				R = 10,
				P = 1.0,
				S = "weapons/hunting_bow"
			},
			{
				R = 20,
				P = 1.0,
				S = "weapons/war_bow"
			},
			{
				R = 20,
				P = 1.0,
				S = "weapons/war_bow"
			},
			{
				R = 10,
				P = 1.0,
				S = "weapons/light_crossbow"
			},
			{
				R = 10,
				P = 1.0,
				S = "weapons/light_crossbow"
			},
			{
				R = 10,
				P = 1.0,
				S = "weapons/crossbow"
			},
			{
				R = 10,
				P = 1.0,
				S = "weapons/crossbow"
			},
			{
				R = 30,
				P = 1.0,
				S = "weapons/heavy_crossbow"
			},
			{
				R = 30,
				P = 1.0,
				S = "weapons/heavy_crossbow"
			},
			{
				R = 10,
				P = 1.0,
				S = "weapons/javelin"
			},
			{
				R = 10,
				P = 1.0,
				S = "weapons/throwing_axe"
			},
			{
				R = 0,
				P = 1.0,
				S = "ammo/quiver_of_arrows"
			},
			{
				R = 0,
				P = 1.0,
				S = "ammo/quiver_of_bolts"
			},
			{
				R = 0,
				P = 1.0,
				S = "supplies/ammo_item"
			}
		];

		if (this.Const.DLC.Unhold)
		{
			list.extend([
				{
					R = 90,
					P = 1.0,
					S = "weapons/throwing_spear"
				}
			]);
		}

		foreach( i in this.Const.Items.NamedRangedWeapons )
		{
			if (this.Math.rand(1, 100) <= 50)
			{
				list.push({
					R = 99,
					P = 2.0,
					S = i
				});
			}
		}

		this.m.Settlement.onUpdateShopList(this.m.ID, list);
		this.fillStash(list, this.m.Stash, 1.25, false);
	}

	function onUpdateDraftList( _list )
	{
		_list.push("bowyer_background");
	}

	function onSerialize( _out )
	{
		this.building.onSerialize(_out);
		this.m.Stash.onSerialize(_out);
	}

	function onDeserialize( _in )
	{
		this.building.onDeserialize(_in);
		this.m.Stash.onDeserialize(_in);
	}

});


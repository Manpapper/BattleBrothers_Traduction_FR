this.weaponsmith_building <- this.inherit("scripts/entity/world/settlements/buildings/building", {
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
		this.m.ID = "building.weaponsmith";
		this.m.Name = "Weaponsmith";
		this.m.Description = "A weaponsmith\'s workshop displaying all kinds of well crafted weapons";
		this.m.UIImage = "ui/settlements/building_04";
		this.m.UIImageNight = "ui/settlements/building_04_night";
		this.m.Tooltip = "world-town-screen.main-dialog-module.Weaponsmith";
		this.m.TooltipIcon = "ui/icons/buildings/weaponsmith.png";
		this.m.IsRepairOffered = true;
		this.m.Stash = this.new("scripts/items/stash_container");
		this.m.Stash.setID("shop");
		this.m.Stash.setResizable(true);
		this.m.Sounds = [
			{
				File = "ambience/buildings/blacksmith_hammering_00.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/blacksmith_hammering_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/blacksmith_hammering_02.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/blacksmith_hammering_03.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/blacksmith_hammering_04.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/blacksmith_hammering_05.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/blacksmith_hammering_06.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/blacksmith_hammering_07.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/blacksmith_hammering_08.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/blacksmith_hammering_09.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/blacksmith_hammering_10.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/blacksmith_hot_water_00.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/blacksmith_scrape_00.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/blacksmith_sharpening_01.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/blacksmith_sharpening_02.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/blacksmith_sharpening_03.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/blacksmith_sharpening_04.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/blacksmith_sharpening_05.wav",
				Volume = 1.0,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/blacksmith_sharpening_06.wav",
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
				R = 20,
				P = 1.0,
				S = "weapons/dagger"
			},
			{
				R = 20,
				P = 1.0,
				S = "weapons/dagger"
			},
			{
				R = 55,
				P = 1.0,
				S = "weapons/rondel_dagger"
			},
			{
				R = 30,
				P = 1.0,
				S = "weapons/boar_spear"
			},
			{
				R = 30,
				P = 1.0,
				S = "weapons/boar_spear"
			},
			{
				R = 50,
				P = 1.0,
				S = "weapons/fighting_spear"
			},
			{
				R = 20,
				P = 1.0,
				S = "weapons/hand_axe"
			},
			{
				R = 20,
				P = 1.0,
				S = "weapons/shortsword"
			},
			{
				R = 20,
				P = 1.0,
				S = "weapons/shortsword"
			},
			{
				R = 10,
				P = 1.0,
				S = "weapons/javelin"
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
				R = 10,
				P = 1.0,
				S = "weapons/throwing_axe"
			},
			{
				R = 45,
				P = 1.0,
				S = "weapons/pike"
			},
			{
				R = 45,
				P = 1.0,
				S = "weapons/pike"
			},
			{
				R = 45,
				P = 1.0,
				S = "weapons/billhook"
			},
			{
				R = 45,
				P = 1.0,
				S = "weapons/longaxe"
			},
			{
				R = 35,
				P = 1.0,
				S = "weapons/falchion"
			},
			{
				R = 35,
				P = 1.0,
				S = "weapons/falchion"
			},
			{
				R = 40,
				P = 1.0,
				S = "weapons/morning_star"
			},
			{
				R = 40,
				P = 1.0,
				S = "weapons/morning_star"
			},
			{
				R = 50,
				P = 1.0,
				S = "weapons/arming_sword"
			},
			{
				R = 50,
				P = 1.0,
				S = "weapons/arming_sword"
			},
			{
				R = 50,
				P = 1.0,
				S = "weapons/military_cleaver"
			},
			{
				R = 40,
				P = 1.0,
				S = "weapons/winged_mace"
			},
			{
				R = 55,
				P = 1.0,
				S = "weapons/fighting_axe"
			},
			{
				R = 65,
				P = 1.0,
				S = "weapons/noble_sword"
			},
			{
				R = 50,
				P = 1.0,
				S = "weapons/military_pick"
			},
			{
				R = 65,
				P = 1.0,
				S = "weapons/warhammer"
			},
			{
				R = 55,
				P = 1.0,
				S = "weapons/flail"
			},
			{
				R = 60,
				P = 1.0,
				S = "weapons/greatsword"
			},
			{
				R = 60,
				P = 1.0,
				S = "weapons/warbrand"
			},
			{
				R = 60,
				P = 1.0,
				S = "weapons/greataxe"
			},
			{
				R = 60,
				P = 1.0,
				S = "weapons/two_handed_hammer"
			}
		];

		if (this.Const.DLC.Unhold)
		{
			list.extend([
				{
					R = 60,
					P = 1.0,
					S = "weapons/two_handed_wooden_hammer"
				},
				{
					R = 50,
					P = 1.0,
					S = "weapons/longsword"
				},
				{
					R = 80,
					P = 1.0,
					S = "weapons/three_headed_flail"
				},
				{
					R = 65,
					P = 1.0,
					S = "weapons/two_handed_flail"
				},
				{
					R = 60,
					P = 1.0,
					S = "weapons/two_handed_wooden_flail"
				},
				{
					R = 80,
					P = 1.0,
					S = "weapons/spetum"
				},
				{
					R = 60,
					P = 1.0,
					S = "weapons/polehammer"
				},
				{
					R = 80,
					P = 1.0,
					S = "weapons/goedendag"
				},
				{
					R = 55,
					P = 1.0,
					S = "weapons/two_handed_mace"
				},
				{
					R = 65,
					P = 1.0,
					S = "weapons/two_handed_flanged_mace"
				},
				{
					R = 80,
					P = 1.0,
					S = "weapons/fencing_sword"
				},
				{
					R = 10,
					P = 1.0,
					S = "weapons/throwing_spear"
				}
			]);
		}

		if (this.Const.DLC.Wildmen)
		{
			if (this.m.Settlement.getTile().SquareCoords.Y > this.World.getMapSize().Y * 0.7)
			{
				list.push({
					R = 70,
					P = 1.0,
					S = "weapons/bardiche"
				});
			}
			else if (this.m.Settlement.getTile().SquareCoords.Y < this.World.getMapSize().Y * 0.4)
			{
				list.push({
					R = 75,
					P = 1.0,
					S = "weapons/scimitar"
				});
				list.push({
					R = 85,
					P = 1.0,
					S = "weapons/shamshir"
				});
			}

			list.push({
				R = 80,
				P = 1.0,
				S = "weapons/battle_whip"
			});
		}

		foreach( i in this.Const.Items.NamedMeleeWeapons )
		{
			if (this.Math.rand(1, 100) <= 30)
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


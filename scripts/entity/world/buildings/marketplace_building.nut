this.marketplace_building <- this.inherit("scripts/entity/world/settlements/buildings/building", {
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
		this.m.ID = "building.marketplace";
		this.m.Name = "Marketplace";
		this.m.Description = "A lively market offering all sorts of goods common in the region";
		this.m.UIImage = "ui/settlements/building_06";
		this.m.UIImageNight = "ui/settlements/building_06_night";
		this.m.Tooltip = "world-town-screen.main-dialog-module.Marketplace";
		this.m.Stash = this.new("scripts/items/stash_container");
		this.m.Stash.setID("shop");
		this.m.Stash.setResizable(true);
		this.m.Sounds = [
			{
				File = "ambience/buildings/market_people_00.wav",
				Volume = 0.4,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_01.wav",
				Volume = 0.6,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_02.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_03.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_04.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_05.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_07.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_08.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_09.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_10.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_11.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_12.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_13.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_people_14.wav",
				Volume = 0.8,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_pig_00.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_pig_01.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_pig_02.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_pig_03.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_pig_04.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_chicken_00.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_chicken_01.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_chicken_02.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_chicken_03.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_chicken_04.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_chicken_05.wav",
				Volume = 0.9,
				Pitch = 1.0
			},
			{
				File = "ambience/buildings/market_bottles_00.wav",
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
				S = "weapons/bludgeon"
			},
			{
				R = 20,
				P = 1.0,
				S = "weapons/militia_spear"
			},
			{
				R = 20,
				P = 1.0,
				S = "weapons/pitchfork"
			},
			{
				R = 10,
				P = 1.0,
				S = "weapons/knife"
			},
			{
				R = 20,
				P = 1.0,
				S = "weapons/hatchet"
			},
			{
				R = 30,
				P = 1.0,
				S = "weapons/short_bow"
			},
			{
				R = 30,
				P = 1.0,
				S = "weapons/javelin"
			},
			{
				R = 30,
				P = 1.0,
				S = "ammo/quiver_of_arrows"
			},
			{
				R = 10,
				P = 1.0,
				S = "armor/sackcloth"
			},
			{
				R = 20,
				P = 1.0,
				S = "armor/linen_tunic"
			},
			{
				R = 25,
				P = 1.0,
				S = "armor/thick_tunic"
			},
			{
				R = 10,
				P = 1.0,
				S = "helmets/straw_hat"
			},
			{
				R = 20,
				P = 1.0,
				S = "helmets/hood"
			},
			{
				R = 15,
				P = 1.0,
				S = "shields/buckler_shield"
			},
			{
				R = 20,
				P = 1.0,
				S = "shields/wooden_shield"
			},
			{
				R = 10,
				P = 1.0,
				S = "supplies/ground_grains_item"
			},
			{
				R = 10,
				P = 1.0,
				S = "supplies/medicine_item"
			},
			{
				R = 0,
				P = 1.0,
				S = "supplies/ammo_item"
			},
			{
				R = 10,
				P = 1.0,
				S = "supplies/armor_parts_item"
			},
			{
				R = 50,
				P = 1.0,
				S = "supplies/armor_parts_item"
			},
			{
				R = 10,
				P = 1.0,
				S = "accessory/bandage_item"
			}
		];

		if (this.m.Settlement.getSize() >= 3)
		{
			list.push({
				R = 50,
				P = 1.0,
				S = "supplies/medicine_item"
			});
			list.push({
				R = 50,
				P = 1.0,
				S = "supplies/armor_parts_item"
			});
		}

		if (this.m.Settlement.getSize() >= 2 && !this.m.Settlement.hasAttachedLocation("attached_location.fishing_huts"))
		{
			list.push({
				R = 50,
				P = 1.0,
				S = "supplies/dried_fish_item"
			});
		}

		if (this.m.Settlement.getSize() >= 3 && !this.m.Settlement.hasAttachedLocation("attached_location.beekeeper"))
		{
			list.push({
				R = 50,
				P = 1.0,
				S = "supplies/mead_item"
			});
		}

		if (this.m.Settlement.getSize() >= 1 && !this.m.Settlement.hasAttachedLocation("attached_location.pig_farm"))
		{
			list.push({
				R = 50,
				P = 1.0,
				S = "supplies/smoked_ham_item"
			});
		}

		if (this.m.Settlement.getSize() >= 2 && !this.m.Settlement.hasAttachedLocation("attached_location.hunters_cabin"))
		{
			list.push({
				R = 50,
				P = 1.0,
				S = "supplies/cured_venison_item"
			});
		}

		if (this.m.Settlement.getSize() >= 3 && !this.m.Settlement.hasAttachedLocation("attached_location.goat_herd"))
		{
			list.push({
				R = 50,
				P = 1.0,
				S = "supplies/goat_cheese_item"
			});
		}

		if (this.m.Settlement.getSize() >= 3 && !this.m.Settlement.hasAttachedLocation("attached_location.orchard"))
		{
			list.push({
				R = 50,
				P = 1.0,
				S = "supplies/dried_fruits_item"
			});
		}

		if (this.m.Settlement.getSize() >= 2 && !this.m.Settlement.hasAttachedLocation("attached_location.mushroom_grove"))
		{
			list.push({
				R = 50,
				P = 1.0,
				S = "supplies/pickled_mushrooms_item"
			});
		}

		if (!this.m.Settlement.hasAttachedLocation("attached_location.wheat_farm"))
		{
			list.push({
				R = 30,
				P = 1.0,
				S = "supplies/bread_item"
			});
		}

		if (this.m.Settlement.getSize() >= 2 && !this.m.Settlement.hasAttachedLocation("attached_location.gatherers_hut"))
		{
			list.push({
				R = 50,
				P = 1.0,
				S = "supplies/roots_and_berries_item"
			});
		}

		if (this.m.Settlement.getSize() >= 2 && !this.m.Settlement.hasAttachedLocation("attached_location.brewery"))
		{
			list.push({
				R = 50,
				P = 1.0,
				S = "supplies/beer_item"
			});
		}

		if (this.m.Settlement.getSize() >= 3 && !this.m.Settlement.hasAttachedLocation("attached_location.winery"))
		{
			list.push({
				R = 50,
				P = 1.0,
				S = "supplies/wine_item"
			});
		}

		if (this.m.Settlement.getSize() >= 3)
		{
			list.push({
				R = 60,
				P = 1.0,
				S = "supplies/cured_rations_item"
			});
		}

		if (this.m.Settlement.getSize() >= 3 || this.m.Settlement.isMilitary())
		{
			list.push({
				R = 90,
				P = 1.0,
				S = "accessory/falcon_item"
			});
		}

		if (this.Const.DLC.Unhold && (this.m.Settlement.isMilitary() && this.m.Settlement.getSize() >= 3 || this.m.Settlement.getSize() >= 2))
		{
			list.push({
				R = 65,
				P = 1.0,
				S = "misc/paint_set_item"
			});
			list.push({
				R = 75,
				P = 1.0,
				S = "misc/paint_remover_item"
			});
			list.push({
				R = 75,
				P = 1.0,
				S = "misc/paint_black_item"
			});
			list.push({
				R = 75,
				P = 1.0,
				S = "misc/paint_red_item"
			});
			list.push({
				R = 75,
				P = 1.0,
				S = "misc/paint_orange_red_item"
			});
			list.push({
				R = 75,
				P = 1.0,
				S = "misc/paint_white_blue_item"
			});
			list.push({
				R = 75,
				P = 1.0,
				S = "misc/paint_white_green_yellow_item"
			});
		}

		if (this.Const.DLC.Unhold)
		{
			list.extend([
				{
					R = 90,
					P = 1.0,
					S = "weapons/two_handed_wooden_hammer"
				}
			]);

			if (this.m.Settlement.isMilitary())
			{
				list.extend([
					{
						R = 80,
						P = 1.0,
						S = "weapons/throwing_spear"
					}
				]);
			}
		}

		if (this.Const.DLC.Wildmen)
		{
			list.extend([
				{
					R = 50,
					P = 1.0,
					S = "weapons/warfork"
				},
				{
					R = 30,
					P = 1.0,
					S = "weapons/staff_sling"
				}
			]);
		}

		this.m.Settlement.onUpdateShopList(this.m.ID, list);
		this.fillStash(list, this.m.Stash, 1.0, true);
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


this.marketplace_oriental_building <- this.inherit("scripts/entity/world/settlements/buildings/marketplace_building", {
	m = {},
	function create()
	{
		this.marketplace_building.create();
		this.m.UIImage = "ui/settlements/desert_building_06";
		this.m.UIImageNight = "ui/settlements/desert_building_06_night";
	}

	function onUpdateShopList()
	{
		local list = [
			{
				R = 10,
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
				R = 30,
				P = 1.0,
				S = "weapons/short_bow"
			},
			{
				R = 60,
				P = 1.0,
				S = "weapons/oriental/composite_bow"
			},
			{
				R = 30,
				P = 1.0,
				S = "weapons/javelin"
			},
			{
				R = 40,
				P = 1.0,
				S = "weapons/oriental/saif"
			},
			{
				R = 70,
				P = 1.0,
				S = "weapons/scimitar"
			},
			{
				R = 40,
				P = 1.0,
				S = "weapons/oriental/light_southern_mace"
			},
			{
				R = 70,
				P = 1.0,
				S = "weapons/oriental/firelance"
			},
			{
				R = 30,
				P = 1.0,
				S = "ammo/quiver_of_arrows"
			},
			{
				R = 10,
				P = 1.0,
				S = "armor/oriental/cloth_sash"
			},
			{
				R = 40,
				P = 1.0,
				S = "armor/oriental/nomad_robe"
			},
			{
				R = 20,
				P = 1.0,
				S = "armor/oriental/padded_vest"
			},
			{
				R = 30,
				P = 1.0,
				S = "armor/oriental/linothorax"
			},
			{
				R = 0,
				P = 1.0,
				S = "helmets/oriental/southern_head_wrap"
			},
			{
				R = 10,
				P = 1.0,
				S = "helmets/oriental/southern_head_wrap"
			},
			{
				R = 30,
				P = 1.0,
				S = "helmets/oriental/wrapped_southern_helmet"
			},
			{
				R = 40,
				P = 1.0,
				S = "helmets/oriental/spiked_skull_cap_with_mail"
			},
			{
				R = 15,
				P = 1.0,
				S = "shields/oriental/southern_light_shield"
			},
			{
				R = 0,
				P = 1.0,
				S = "supplies/rice_item"
			},
			{
				R = 50,
				P = 1.0,
				S = "supplies/rice_item"
			},
			{
				R = 0,
				P = 1.0,
				S = "supplies/medicine_item"
			},
			{
				R = 0,
				P = 1.0,
				S = "supplies/medicine_item"
			},
			{
				R = 50,
				P = 1.0,
				S = "supplies/medicine_item"
			},
			{
				R = 0,
				P = 1.0,
				S = "supplies/ammo_item"
			},
			{
				R = 0,
				P = 1.0,
				S = "supplies/ammo_item"
			},
			{
				R = 50,
				P = 1.0,
				S = "supplies/ammo_item"
			},
			{
				R = 0,
				P = 1.0,
				S = "supplies/armor_parts_item"
			},
			{
				R = 0,
				P = 1.0,
				S = "supplies/armor_parts_item"
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
			},
			{
				R = 20,
				P = 1.0,
				S = "tools/throwing_net"
			}
		];

		if (this.m.Settlement.getSize() >= 2 && !this.m.Settlement.hasAttachedLocation("attached_location.fishing_huts"))
		{
			list.push({
				R = 50,
				P = 1.0,
				S = "supplies/dried_fish_item"
			});
		}

		if (this.m.Settlement.getSize() >= 3 && !this.m.Settlement.hasAttachedLocation("attached_location.goat_herd"))
		{
			list.push({
				R = 50,
				P = 1.0,
				S = "supplies/goat_cheese_item"
			});
			list.push({
				R = 50,
				P = 1.0,
				S = "supplies/dried_lamb_item"
			});
		}

		if (this.m.Settlement.getSize() >= 3 && !this.m.Settlement.hasAttachedLocation("attached_location.plantation"))
		{
			list.push({
				R = 50,
				P = 1.0,
				S = "supplies/dates_item"
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
				},
				{
					R = 80,
					P = 1.0,
					S = "weapons/throwing_spear"
				}
			]);
		}

		if (this.Const.DLC.Wildmen)
		{
			list.extend([
				{
					R = 50,
					P = 1.0,
					S = "weapons/warfork"
				}
			]);
		}

		this.m.Settlement.onUpdateShopList(this.m.ID, list);
		this.fillStash(list, this.m.Stash, 1.0, true);
	}

});


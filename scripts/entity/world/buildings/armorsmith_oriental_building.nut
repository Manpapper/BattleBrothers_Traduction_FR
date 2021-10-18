this.armorsmith_oriental_building <- this.inherit("scripts/entity/world/settlements/buildings/armorsmith_building", {
	m = {
		Stash = null
	},
	function getStash()
	{
		return this.m.Stash;
	}

	function create()
	{
		this.armorsmith_building.create();
		this.m.ID = "building.armorsmith_oriental";
		this.m.UIImage = "ui/settlements/desert_building_01";
		this.m.UIImageNight = "ui/settlements/desert_building_01_night";
	}

	function onUpdateShopList()
	{
		local list = [
			{
				R = 0,
				P = 1.0,
				S = "armor/oriental/linothorax"
			},
			{
				R = 10,
				P = 1.0,
				S = "armor/oriental/padded_vest"
			},
			{
				R = 40,
				P = 1.0,
				S = "armor/oriental/mail_and_lamellar_plating"
			},
			{
				R = 60,
				P = 1.0,
				S = "armor/oriental/padded_mail_and_lamellar_hauberk"
			},
			{
				R = 35,
				P = 1.0,
				S = "armor/oriental/southern_long_mail_with_padding"
			},
			{
				R = 25,
				P = 1.0,
				S = "armor/oriental/southern_mail_shirt"
			},
			{
				R = 50,
				P = 1.0,
				S = "armor/mail_shirt"
			},
			{
				R = 70,
				P = 1.0,
				S = "armor/mail_hauberk"
			},
			{
				R = 70,
				P = 1.0,
				S = "armor/scale_armor"
			},
			{
				R = 85,
				P = 1.0,
				S = "armor/lamellar_harness"
			},
			{
				R = 85,
				P = 1.0,
				S = "armor/heavy_lamellar_armor"
			},
			{
				R = 30,
				P = 1.0,
				S = "shields/oriental/southern_light_shield"
			},
			{
				R = 30,
				P = 1.0,
				S = "shields/oriental/southern_light_shield"
			},
			{
				R = 30,
				P = 1.0,
				S = "shields/oriental/southern_light_shield"
			},
			{
				R = 30,
				P = 1.0,
				S = "shields/oriental/metal_round_shield"
			},
			{
				R = 30,
				P = 1.0,
				S = "shields/oriental/metal_round_shield"
			},
			{
				R = 40,
				P = 1.0,
				S = "helmets/oriental/heavy_lamellar_helmet"
			},
			{
				R = 0,
				P = 1.0,
				S = "helmets/oriental/southern_head_wrap"
			},
			{
				R = 30,
				P = 1.0,
				S = "helmets/oriental/southern_helmet_with_coif"
			},
			{
				R = 20,
				P = 1.0,
				S = "helmets/oriental/spiked_skull_cap_with_mail"
			},
			{
				R = 65,
				P = 1.0,
				S = "helmets/oriental/turban_helmet"
			},
			{
				R = 30,
				P = 1.0,
				S = "helmets/oriental/wrapped_southern_helmet"
			},
			{
				R = 60,
				P = 1.0,
				S = "helmets/mail_coif"
			}
		];

		foreach( i in this.Const.Items.NamedArmors )
		{
			if (this.Math.rand(1, 100) <= 33)
			{
				list.push({
					R = 99,
					P = 2.0,
					S = i
				});
			}
		}

		foreach( i in this.Const.Items.NamedHelmets )
		{
			if (this.Math.rand(1, 100) <= 33)
			{
				list.push({
					R = 99,
					P = 2.0,
					S = i
				});
			}
		}

		if (this.Const.DLC.Unhold)
		{
			list.push({
				R = 60,
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
			list.push({
				R = 85,
				P = 1.25,
				S = "armor_upgrades/metal_plating_upgrade"
			});
			list.push({
				R = 85,
				P = 1.25,
				S = "armor_upgrades/metal_pauldrons_upgrade"
			});
			list.push({
				R = 85,
				P = 1.25,
				S = "armor_upgrades/mail_patch_upgrade"
			});
			list.push({
				R = 85,
				P = 1.25,
				S = "armor_upgrades/leather_shoulderguards_upgrade"
			});
			list.push({
				R = 85,
				P = 1.25,
				S = "armor_upgrades/leather_neckguard_upgrade"
			});
			list.push({
				R = 85,
				P = 1.25,
				S = "armor_upgrades/joint_cover_upgrade"
			});
			list.push({
				R = 85,
				P = 1.25,
				S = "armor_upgrades/heraldic_plates_upgrade"
			});
			list.push({
				R = 85,
				P = 1.25,
				S = "armor_upgrades/double_mail_upgrade"
			});
		}

		this.m.Settlement.onUpdateShopList(this.m.ID, list);
		this.fillStash(list, this.m.Stash, 1.25, false);
	}

});


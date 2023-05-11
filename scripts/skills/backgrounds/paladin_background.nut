this.paladin_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.paladin";
		this.m.Name = "Prêteur de Serments";
		this.m.Icon = "ui/backgrounds/background_69.png";
		this.m.BackgroundDescription = "Les prêteurs de serments sont des guerriers courageux qui ont juré de respecter un code strict et ne sont pas étrangers au combat.";
		this.m.GoodEnding = "%name% le prêteur de serments est resté avec la compagnie %companyname%, brandissant le crâne du Jeune Anselm pour faire du prosélytisme sur les vertus chevaleresques dans le monde. La plupart des gens le considèrent comme une source d\'ennui, mais il y a aussi du charme chez un homme qui croit pleinement aux questions d\'honneur et de fierté et qui fait le bien. Aux dernières nouvelles, il a sauvé d\'une seule main la princesse d\'un seigneur d\'une bande de voleurs de rue. En guise de récompense, il s\'est marié avec la demoiselle. Les rumeurs disent qu\'elle serait malheureuse au lit et ça ne viendrait certainement pas du fait que le Oathtaker exige que le crâne du jeune Anselm soit dans la chambre à coucher. Mais dans le fond, peu importe, vous êtes heureux que l\'homme continue à bien faire son travail.";
		this.m.BadEnding = "Étant autrefois un prêteur de serments jusqu\'à la moelle, %name% a été déçu par ses coreligionnaires et a rêvé une nuit qu\'ils étaient en fait de vrais hérétiques. Il a tué tous les Oathtakers à sa portée et s\'est ensuite enfui, rejoignant finalement les Oathbringers. La dernière fois qu\'on a entendu parler de lui, il avait récupéré le crâne du jeune Anselm et l\'avait brisé avec un marteau. Furieux, ses nouveaux frères l\'ont rapidement abattu. Le cadavre de %name% a été retrouvé poignardé plus de cent fois, des fragments de crâne cendrés poudrant son visage ensanglanté, au sourire fou.";
		this.m.HiringCost = 150;
		this.m.DailyCost = 22;
		this.m.Titles = [
			"the Crusader",
			"le zélote",
			"the Pious",
			"the Devoted",
			"the Paladin",
			"the Righteous",
			"the Oathbound",
			"the Oathsworn",
			"the Virtuous"
		];
		this.m.Excluded = [
			"trait.ailing",
			"trait.asthmatic",
			"trait.bleeder",
			"trait.bright",
			"trait.clubfooted",
			"trait.clumsy",
			"trait.craven",
			"trait.dastard",
			"trait.disloyal",
			"trait.drunkard",
			"trait.fainthearted",
			"trait.fear_beasts",
			"trait.fear_greenskins",
			"trait.fear_undead",
			"trait.fragile",
			"trait.greedy",
			"trait.hesitant",
			"trait.insecure",
			"trait.paranoid",
			"trait.tiny",
			"trait.tough",
			"trait.weasel"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.RangedSkill
		];
		this.m.Bodies = this.Const.Bodies.Muscular;
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.AllMale;
		this.m.HairColors = this.Const.HairColors.Young;
		this.m.Beards = this.Const.Beards.All;
		this.m.BeardChance = 60;
		this.m.Level = this.Math.rand(1, 3);
		this.m.IsCombatBackground = true;
	}

	function getTooltip()
	{
		return [
			{
				id = 1,
				type = "title",
				text = this.getName()
			},
			{
				id = 2,
				type = "description",
				text = this.getDescription()
			}
		];
	}

	function onBuildDescription()
	{
		return "{Oathbringers. Oathbringers. Oathbringers. Oathbringers. Oathbringers. Oathbringers. Oathbringers. Oathbringers. Oathbringers. Oathbringers. Oathbringers. Oathbringers!\n\nOathbringers Oathbringers Oathbringers Oathbringers Oathbringers Oathbringers!!!\n\nOATHBRINGERS OATHBRINGERS OATHBRINGERS!!! | %name% est un disciple assidu du célèbre fondateur des Oathtakers, le jeune Anselm. Il se considère béni d\'être en compagnie d\'hommes aux convictions similaires qui, même s\'ils ne sont pas sans défaut, essaient de faire le bien dans le monde. | Certains disent que %name% était un Oathtaker dès sa naissance. C\'est lui-même qui le dit le plus souvent, ce qui conduit à certaines spéculations selon lesquelles il était certainement un terrible dégénéré et qu\'il essaye juste de se racheter de son horrible passé. | Quand on pense à un Oathtaker, %name% en est la pure représentation. Il garde son uniforme et son armure propres et bien rangés. Il respecte ses supérieurs sans hypocrisie aucune. Et il est absolument excellent pour diriger l\'acier vers le visage d\'un Oathbringer. Un Oathtaker exceptionnel s\'il en est. | Vivant dans un pays lointain, chassant l\'honneur et apportant la mort aux Oathbringers, %name% a entendu parler du passé prestigieux de la compagnie %companyname% et ne pouvait que la trouver et la rejoindre. C\'est un homme d\'une incroyable détermination et surtout, il ne badine pas avec les Oathbringers. | L\'esprit du jeune Anselm a amené %name% a la compagnie %companyname%. C\'est du moins ce qu\'il dit. Peu importe ce qui l\'a amené dans la compagnie, il est sans aucun doute un combattant talentueux et sera très utile. | La grandeur d\'esprit du jeune Anselm ne peut être considérée comme acquise. C\'est du moins ce que croit %name%. Il déclare qu\'il se bat au nom du défunt Oathtaker. Le jeune Anselm devait être un garçon vif d\'esprit en effet, cet homme a un talent certain avec n\'importe quel acier. | Comme beaucoup d\'Oathtakers, %name% connaît trois principes divins : L\'esprit du jeune Anselm doit être chéri, les serments doivent être pris au sérieux et tous les Oathbringers doivent mourir. Gagner un peu d\'argent à côté est également agréable, c\'est pourquoi il a fait de son \"quatrième\" principe la possibilité de travailler pour des organisations comme la compagnie %companyname%. | C\'est un peu particulier pour un Oathtaker de gagner sa croute en étant mercenaire, mais %name% affirme que cela n\'a jamais été interdit par les enseignements du jeune Anselm. Au lieu de cela, il est de la responsabilité personnelle de chaque Oathtakers de tenir leurs serments, ce qu\'il peut facilement faire en tuant des ennemis de la compagnie %companyname%. | %name% a un livre de comptes dédié à un seul type de produit: le nombre d\'Oathbringers qu\'il a tué. Il a même une liste de quand et où il a fait l\'acte, et bien sûr comment. Les entrées du \"comment\" bénéficient même d\'un peu plus de précisions, avec des lignes et des lignes décrivant méticuleusement comment il s\'est débarrassé de ses ennemis jurés. Honnêtement, vous aimez l\'enthousiasme de cet homme. | %name%, un Oathtaker, est d\'un esprit si singulier qu\'on se demande presque ce qu\'il ferait sans les directives du jeune Anselm. Cela dit, une partie de vous est curieuse de savoir comment il s\'en sortirait s\'il se consacrait à un autre métier. Avec sa détermination et son dynamisme, il pourrait probablement être un vannier hors pair, peut-être même le faire sous l\'eau comme ces experts savants. | %name% est tout ce que l\'on peut attendre d\'un homme honorable : intelligent, en bonne santé et capable de manier l\'acier. Son dévouement aux serments(Oaths) n\'a d\'égal que sa capacité à démolir absolument tout ceux qui se trouvent sur son chemin. Un complément vraiment parfait pour la compagnie %companyname%. | La compagnie %companyname% gagnant en renommée, elle devient l\'une des formations les plus réputées du pays. Naturellement, un homme doué et respectable comme %name% chercherait à s\'engager, mais à un prix. Ses services à la cause du Jeune Anselm signifie que son attention est sans doute partagée, mais même s\'il est dévoré par la justice, il reste un combattant infatigable qui mérite d\'être présent dans la compagnie %companyname%.}";
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");
		local tattoo_head = actor.getSprite("tattoo_head");

		if (this.Math.rand(1, 100) <= 25)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 30)
		{
			tattoo_head.setBrush("scar_02_head");
			tattoo_head.Visible = true;
		}
	}

	function updateAppearance()
	{
		local actor = this.getContainer().getActor();
		local tattoo_body = actor.getSprite("tattoo_body");

		if (tattoo_body.HasBrush)
		{
			local body = actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
		}
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				10,
				6
			],
			Bravery = [
				13,
				16
			],
			Stamina = [
				0,
				-4
			],
			MeleeSkill = [
				13,
				10
			],
			RangedSkill = [
				-2,
				-3
			],
			MeleeDefense = [
				4,
				5
			],
			RangedDefense = [
				-10,
				-5
			],
			Initiative = [
				13,
				12
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;

		if (items.hasEmptySlot(this.Const.ItemSlot.Mainhand))
		{
			local weapons = [
				"weapons/arming_sword",
				"weapons/fighting_axe",
				"weapons/winged_mace",
				"weapons/military_pick",
				"weapons/warhammer",
				"weapons/billhook",
				"weapons/longaxe",
				"weapons/greataxe",
				"weapons/greatsword"
			];

			if (this.Const.DLC.Unhold)
			{
				weapons.extend([
					"weapons/longsword",
					"weapons/polehammer",
					"weapons/two_handed_flail",
					"weapons/two_handed_flanged_mace"
				]);
			}

			if (this.Const.DLC.Wildmen)
			{
				weapons.extend([
					"weapons/bardiche"
				]);
			}

			items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
		}

		if (items.hasEmptySlot(this.Const.ItemSlot.Offhand) && this.Math.rand(1, 100) <= 75)
		{
			local shields = [
				"shields/wooden_shield",
				"shields/wooden_shield",
				"shields/heater_shield",
				"shields/kite_shield"
			];
			items.equip(this.new("scripts/items/" + shields[this.Math.rand(0, shields.len() - 1)]));
		}

		r = this.Math.rand(0, 5);

		if (r < 3)
		{
			items.equip(this.new("scripts/items/armor/adorned_mail_shirt"));
		}
		else if (r < 5)
		{
			items.equip(this.new("scripts/items/armor/adorned_warriors_armor"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/armor/adorned_heavy_mail_hauberk"));
		}

		r = this.Math.rand(0, 5);

		if (r < 3)
		{
			items.equip(this.new("scripts/items/helmets/heavy_mail_coif"));
		}
		else if (r < 5)
		{
			items.equip(this.new("scripts/items/helmets/adorned_closed_flat_top_with_mail"));
		}
		else if (r == 5)
		{
			items.equip(this.new("scripts/items/helmets/adorned_full_helm"));
		}
	}

});


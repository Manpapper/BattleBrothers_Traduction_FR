this.executioner_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.executioner";
		this.m.Name = "Bourreau";
		this.m.Icon = "ui/backgrounds/background_72.png";
		this.m.BackgroundDescription = "Les bourreaux sont austères et habitués à la violence, même s\'ils n\'ont guère d\'expérience de la guerre proprement dite.";
		this.m.GoodEnding = "Alors que la compagnie %companyname% visitait la ville pour se reposer et reprendre des forces, une princesse locale a eu le coup de foudre pour %name%, l\'homme sauvage. Il avait été \"acheté\" pour une somme considérable d’or, puis offert à la noble. Vous êtes allé rendre visite à cet homme récemment. Au dîner, il était assis à une table royale, arborant un sourire niais et imitant tant bien que mal les nobles qui l’entouraient. Sa nouvelle épouse, dont l’origine restait un mystère, l’adorait, et lui l’adorait en retour. Lorsque vous lui avez dit au revoir, il vous a offert une lourde couronne d’or qu’il venait de retirer de sa tête. Elle était chargée de traditions et d’histoires anciennes. Vous lui avait dit qu\'il serait mieux qu’il la garde. Le sauvage haussa les épaules et s’éloigna en faisant tourner le diadème autour de son doigt.";
		this.m.BadEnding = "%name% le sauvage est resté quelque temps au sein de la compagnie %companyname%, alors en pleine désagrégation, puis, d\'un seul coup, il a disparu. La compagnie est partie à sa recherche dans la forêt et a fini par trouver une sorte de note rudimentaire : un énorme tas de couronnes à côté d\'un dessin tracé dans la terre représentant la compagnie %companyname% et certains de ses membres, tous enlacés par un grand bonhomme allumette, avec un sourire niais sur le visage. Il y avait également une offrande : un lapin mort, à moitié dévoré.";
		this.m.HiringCost = 100;
		this.m.DailyCost = 12;
		this.m.Excluded = [
			"trait.fragile",
			"trait.teamplayer",
			"trait.hate_beasts",
			"trait.hate_greenskins",
			"trait.hate_undead",
			"trait.lucky",
			"trait.clubfooted",
			"trait.cocky",
			"trait.clumsy",
			"trait.hesitant",
			"trait.fainthearted",
			"trait.craven",
			"trait.fearless",
			"trait.optimist"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.RangedSkill
		];
		this.m.Titles = [
			"preneur de tête",
			"séparateur de cou",
			"la Hache",
			"le juge",
			"le bourreau",
			"le bourreau",
			"le pendeur"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.All;
		this.m.BeardChance = 50;
		this.m.Bodies = this.Const.Bodies.Big;
		this.m.Level = this.Math.rand(1, 3);
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
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/chance_to_hit_head.png",
				text = "Chance augmentés de toucher la tête"
			}
		];
	}

	function onBuildDescription()
	{
		return "{Comme c\'est le cas pour beaucoup d\'hommes, le aprcours de %name% a été dicté par l\'entreprise familiale : exécuter des criminels pour le compte du bourgmestre de %randomtown%. | Quand il était petit, %name% rêvait de devenir un chevalier vêtu d\'une armure étincelante. Une fois adulte, il devint un bourreau vêtu d\'une capuche sombre. | Toute la famille de %name% a été massacrée lors d\'une attaque de bandits. Ne pouvant pas participer lui-même à la chasse à l\'homme, il est devenu l\'apprenti du bourreau local dans l\'espoir de pouvoir un jour se venger à sa manière. | Autrefois brigand lui-même, %name% a changé d\'avis et s\'est rendu aux autorités. La garde locale lui a proposé une grâce s\'il acceptait d\'exécuter tous les criminels qu\'elle capturerait, et il exerce ce métier depuis lors. | Avec ce regard lointain de celui qui a vu beaucoup de morts, et cette lame usée de celui qui les a infligées, il est évident que %name% est un bourreau. | %name%, un bourreau, est à peu près aussi joyeux que la potence qu\'il manie.} {Bien qu’il était satisfait de son métier, celui-ci le rendait impopulaire. Après avoir procédé à la décapitation d\'{ un jeune de la région condamné pour avoir volé un noble | une prostituée bien-aimée qui a couché avec le mauvais seigneur | un artisan réputé, accusé de détournement de fonds}, il a été mis au ban de la ville par ses concitoyens. | Il s\'est toujours considéré comme un élément indispensable, bien que macabre, de la justice au service du peuple. Mais lorsqu\'il a appris {que son employeur concluait des accords secrets avec des brigands | que le seigneur local ordonnait l\'exécution d\'innocents | qu\'un homme qu\'il a exécuté était innocent | les horreurs que le seigneur local a commises avec les têtes des condamnés}, il a démissionné de son poste, dégoûté. | Un jour, on lui confia la mission d’éliminer un étrange adepte d’une secte venu de contrées lointaines. Après avoir brisé une troisième lame en coupant le cou de cet homme étrangement enjoué, il décida qu’il était temps de se trouver un nouveau métier. | Mais un jour, il s’est réveillé et s’est rendu compte qu’il ne supportait plus l’idée de tuer un homme incapable de se défendre. | Mais il finit par se lasser de son rôle, ne trouvant guère de satisfaction à tuer des hommes après qu’ils avaient déjà commis leurs méfaits.} {Comme peu d\'autres carrières s\'offraient à lui, %name% a estimé que le métier de mercenaire était celui qui correspondait le mieux à ses talents. | Même s\'il n\'est pas un guerrier, %name% sait manier l\'épée; c\'est donc tout naturellement qu\'il s\'est reconverti dans le métier d\'épéiste. | Avec un savoir-faire principalement axé sur les décolletés, %name% s\'est dit qu\'il pouvait soit devenir mercenaire, soit tailleur. La première option semblait mieux rémunérée, et le voilà donc ici aujourd\'hui. | Ayant besoin de se réorienter professionnellement mais ne disposant que de peu d\'autres compétences, %name% s\'est dit que le métier de mercenaire revenait en quelque sorte à exécuter quelqu\'un, mais en plusieurs étapes.} {L\'homme se tient silencieusement devant vous, les yeux écarquillés, l\'air plein d\'attente, mais sans dire un mot. Bon, d\'accord. | Moins à l\'aise dans la conversation que dans l\'art de tuer, il vous adresse un salut marmonné, l\'air nerveux, et vous interroge sur la rémunération. | Peu loquace, il vous lance un grognement plein d\'attente. Tant qu\'il peut tuer, vous vous dites que ce silence ne vous dérange pas. | Il s\'approche et vous aboie quelque chose que sa lourde capuche étouffe au point de le rendre incompréhensible. Après quelques instants de silence, il ajoute \"s\'il vous plaît ?\" et vous comprenez qu\'il vous demande de le laisser se joindre à vous. Oh.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				10,
				7
			],
			Bravery = [
				12,
				10
			],
			Stamina = [
				9,
				14
			],
			MeleeSkill = [
				6,
				8
			],
			RangedSkill = [
				-5,
				0
			],
			MeleeDefense = [
				-5,
				0
			],
			RangedDefense = [
				-5,
				-5
			],
			Initiative = [
				-5,
				-5
			]
		};
		return c;
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

		if (this.Math.rand(1, 100) <= 25)
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

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local weapons = [
			"weapons/hatchet",
			"weapons/hand_axe",
			"weapons/exesword",
			"weapons/woodcutters_axe"
		];

		if (this.Const.DLC.Wildmen)
		{
			weapons.extend([
				"weapons/bardiche"
			]);
		}

		items.equip(this.new("scripts/items/" + weapons[this.Math.rand(0, weapons.len() - 1)]));
		local armor = [
			"armor/leather_wraps",
			"armor/executioner_tunic"
		];

		if (this.Math.rand(0, 100) < 66)
		{
			items.equip(this.new("scripts/items/" + armor[this.Math.rand(0, armor.len() - 1)]));
		}

		local helmets = [
			"helmets/executioner_hood",
			"helmets/executioner_hood_open"
		];
		items.equip(this.new("scripts/items/" + helmets[this.Math.rand(0, helmets.len() - 1)]));
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.HitChance[this.Const.BodyPart.Head] += 10;
	}

});


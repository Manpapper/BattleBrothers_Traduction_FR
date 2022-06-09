this.bowyer_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.bowyer";
		this.m.Name = "Archer";
		this.m.Icon = "ui/backgrounds/background_29.png";
		this.m.BackgroundDescription = "Les archers ont tendance à avoir quelques connaissances sur l\'utilisation des armes à distance qu\'ils fabriquent.";
		this.m.GoodEnding = "Lors d\'un tournoi de joute, un jeune garçon utilisait un arc de forme étrange, mais parfaitement conçu. Sa visée était tremblante, mais les flèches n\'ont pas vacillé lorsqu\'elles ont été décochées. Après qu\'il ait gagné la compétition, vous avez demandé où le garçon avait obtenu un arc aussi incroyable. Il a déclaré qu\'un archer du nom de %name% l\'avait fabriqué. Apparemment, il est connu pour fabriquer les meilleurs arcs de tout le pays !";
		this.m.BadEnding = "Après avoir quitté la compagnie %companyname%, vous avez envoyé une lettre pour vous renseigner sur le statut de %name% le fabricant d'arc. Vous avez appris qu\'il avait découvert un moyen de fabriquer le meilleur arc possible et, au lieu de donner ce secret à la compagnie, il est parti créer la sienne. Il n\'est pas allé loin : tout ce qu\'il avait appris sur son métier est mort avec lui sur une route boueuse. En direction {du nord | du sud | de l\'ouest | de l'\est}, il se dit que son corps est ironiquement embroché avec une douzaine de flèches";
		this.m.HiringCost = 80;
		this.m.DailyCost = 8;
		this.m.Excluded = [
			"trait.fear_undead",
			"trait.hate_undead",
			"trait.iron_jaw",
			"trait.athletic",
			"trait.clumsy",
			"trait.short_sighted",
			"trait.fearless",
			"trait.brave",
			"trait.iron_lungs",
			"trait.strong",
			"trait.tough",
			"trait.cocky",
			"trait.dumb",
			"trait.brute",
			"trait.bloodthirsty"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.MeleeSkill
		];
		this.m.Titles = [
			"the Bowyer",
			"the Fletcher",
			"the Arrowmaker",
			"the Patient"
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.TidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Tidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
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
		return "{Avec ses mains calleuses et son œil pour les cordes fines, étrange que | Né d\'un forgeron, il est certainement quelque peu curieux que | Prendre son métier d\'une longue lignée d\'ancêtres clairvoyants,} %name% soit un ajusteur et un archer. {Il a exercé son métier pour la royauté, mais sa carrière s\'est terminée lorsqu\'une corde d\'arc a cassé, coupant le doigt d\'un héritier prometteur. | Malheureusement, la guerre a détruit les forêts d\'où il tirait le meilleur bois. | Malheureusement, il a vendu un arc à un jeune garçon, ce qui a conduit à un horrible accident lié à une flèche. Après de nombreux débats, il n\'était plus désiré en ville. | Mais après tant d\'années à fabriquer des armes pour les autres, il a commencé à se demander ce qu\'il y avait d\'autre dans la vie que le bois et la corde.} {Maintenant, %name% cherche une autre voie. S\'il ne peut pas vendre d\'arcs, il peut peut-être les utiliser. | Maintenant, %name% se repose en compagnie des hommes qu\'il fournissait. | Avec la disparition de son intérêt pour la fabrication d\'arcs, l\'ancien archetier peut-il tirer des flèches aussi bien qu\'il les fabrique ?}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				0,
				0
			],
			Bravery = [
				-5,
				0
			],
			Stamina = [
				-5,
				0
			],
			MeleeSkill = [
				0,
				0
			],
			RangedSkill = [
				10,
				10
			],
			MeleeDefense = [
				0,
				0
			],
			RangedDefense = [
				0,
				0
			],
			Initiative = [
				0,
				0
			]
		};
		return c;
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 1);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/weapons/hunting_bow"));
		}
		else if (r == 1)
		{
			items.equip(this.new("scripts/items/weapons/short_bow"));
		}

		items.equip(this.new("scripts/items/ammo/quiver_of_arrows"));
		r = this.Math.rand(0, 0);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/apron"));
		}

		r = this.Math.rand(0, 2);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/helmets/feathered_hat"));
		}
	}

});


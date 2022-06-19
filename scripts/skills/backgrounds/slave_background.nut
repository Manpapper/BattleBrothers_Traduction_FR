this.slave_background <- this.inherit("scripts/skills/backgrounds/character_background", {
	m = {},
	function create()
	{
		this.character_background.create();
		this.m.ID = "background.slave";
		this.m.Name = "Endetté";
		this.m.Icon = "ui/backgrounds/background_60.png";
		this.m.BackgroundDescription = "Les endettés constituent une caste d\'esclaves dans les cités-États. En tant que tels, ils ne sont pas engagés, mais achetés, et ne reçoivent pas de salaire quotidien.";
		this.m.GoodEnding = "%name% l\'endetté a eu une vie difficile et vous avez à la fois contribué à cela et aidé à l\'alléger d\'une manière ou d\'une autre. Vous l\'avez trouvé comme esclave dans le sud, loin de sa famille et de sa maison. Vous l\'avez \"embauché\" gratuitement et l\'avez fait travailler comme mercenaire asservi. Après votre départ de la compagnie %companyname%, son nom a été retiré du registre des débiteurs et il était à toutes fins utiles un homme libre. Il est resté dans l\'entreprise et n\'a cessé de gravir les échelons depuis. Vous avez une relation étrange avec cet homme. Il ne vous a jamais remercié, et n\'a pas non plus exprimé son mécontentement.";
		this.m.BadEnding = "Après votre retrait de l\'infructueuse compagnie %companyname%, %name%, l\'endetté du nord est resté avec la compagnie pendant un certain temps. Vous avez eu vent que le groupe de mercenaires avait des problèmes financiers et vendait hommes et matériel pour joindre les deux bouts. Il semblerait que le temps de %name% avec la compagnie se soit terminé à ce moment-là, et que son temps en tant qu\'esclave ait recommencé.";
		this.m.HiringCost = this.Math.rand(19, 22) * 10;
		this.m.DailyCost = 0;
		this.m.Titles = [
			"the Enslaved",
			"the Northerner",
			"the Captive",
			"the Pale",
			"the Prisoner",
			"the Kidnapped",
			"the Unlucky",
			"the Indebted",
			"the Indebted",
			"the Unfree",
			"the Restrained",
			"the Shackled",
			"the Bound"
		];
		this.m.Excluded = [
			"trait.survivor",
			"trait.iron_jaw",
			"trait.tough",
			"trait.strong",
			"trait.spartan",
			"trait.gluttonous",
			"trait.lucky",
			"trait.loyal",
			"trait.cocky",
			"trait.fat",
			"trait.fearless",
			"trait.brave",
			"trait.drunkard",
			"trait.determined",
			"trait.greedy",
			"trait.athletic",
			"trait.hate_beasts",
			"trait.hate_undead",
			"trait.hate_greenskins"
		];
		this.m.ExcludedTalents = [
			this.Const.Attributes.Hitpoints,
			this.Const.Attributes.Bravery
		];
		this.m.Faces = this.Const.Faces.AllMale;
		this.m.Hairs = this.Const.Hair.UntidyMale;
		this.m.HairColors = this.Const.HairColors.All;
		this.m.Beards = this.Const.Beards.Untidy;
		this.m.Bodies = this.Const.Bodies.Skinny;
		this.m.IsLowborn = true;
	}

	function getTooltip()
	{
		local ret = [
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
		ret.push({
			id = 19,
			type = "text",
			icon = "ui/icons/special.png",
			text = "No morale check triggered for non-indebted allies upon dying"
		});
		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Sera toujours satisfait d\'être en réserve"
		});
		return ret;
	}

	function onBuildDescription()
	{
		return "{Vous pouvez dire que %name% est un nordiste rien qu\'à son apparence. Et sa servitude dans le sud est due à sa dette envers le Gilder qu\'il a transgressé avec sa foi pour les anciens dieux hérétiques. | %name% porte les traits d\'un nordique, attirant facilement le regard des hommes ou des femmes qui passent. Il a également attiré l\'attention d\'un prêtre qui a prétendu que le nordique était redevable au Gilder et a rapidement vendu l\'intrus en tant que serviteur. | Originaire du nord, %name% était autrefois un soldat envoyé en patrouille dans le sud. Perdu dans le désert, sa troupe s\'est lentement réduite jusqu\'à ce qu\'il soit le dernier survivant. Des chasseurs d\'hommes l\'ont attrapé et l\'ont rafistolé, et bien sûr l\'ont vendu comme esclave une fois que son corps guéri a eu de la valeur. | Bien qu\'il soit originaire du nord et donc facilement repérable, %name% a imprudemment recherché la vie de délinquant et a été surpris en train de voler des grenades dans le jardin d\'un Vizir. Il a eu la chance de garder sa tête, mais sert maintenant de marchandise sur les marchés des chasseurs d\'hommes.}";
	}

	function onChangeAttributes()
	{
		local c = {
			Hitpoints = [
				-10,
				-10
			],
			Bravery = [
				-5,
				0
			],
			Stamina = [
				0,
				0
			],
			MeleeSkill = [
				0,
				0
			],
			RangedSkill = [
				0,
				0
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
				-5,
				-5
			]
		};
		return c;
	}

	function onSetAppearance()
	{
		local actor = this.getContainer().getActor();
		local dirt = actor.getSprite("dirt");
		dirt.Visible = true;

		if (this.Math.rand(1, 100) <= 66)
		{
			local body = actor.getSprite("body");
			local tattoo_body = actor.getSprite("tattoo_body");
			tattoo_body.setBrush("scar_01_" + body.getBrush().Name);
			tattoo_body.Color = body.Color;
			tattoo_body.Saturation = body.Saturation;
			tattoo_body.Visible = true;
		}
	}

	function onAddEquipment()
	{
		local items = this.getContainer().getActor().getItems();
		local r;
		r = this.Math.rand(0, 4);

		if (r == 0)
		{
			items.equip(this.new("scripts/items/armor/tattered_sackcloth"));
		}

		if (r == 1)
		{
			items.equip(this.new("scripts/items/armor/leather_wraps"));
		}
	}

	function onUpdate( _properties )
	{
		this.character_background.onUpdate(_properties);
		_properties.IsContentWithBeingInReserve = true;

		if (("State" in this.World) && this.World.State != null && this.World.Assets.getOrigin() != null && this.World.Assets.getOrigin().getID() == "scenario.manhunters")
		{
			_properties.XPGainMult *= 1.1;
			_properties.SurviveWithInjuryChanceMult = 0.0;
		}
	}

});


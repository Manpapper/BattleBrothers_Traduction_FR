this.defeat_orc_location_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		Defeated = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_orc_location";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Battre les orcs au combat et brûler certains de leurs camps ferait connaître aux gens les capacités de la compagnie sur le champ de bataille. Allons-y !";
		this.m.RewardTooltip = "Vous recevrez un accessoire unique qui rendra son porteur insensible aux étourdissements.";
		this.m.UIText = "Détruire les lieux contrôlés par les orcs";
		this.m.TooltipText = "Détruisez quatre lieux contrôlés par des orcs pour prouver les prouesses de la compagnie, que ce soit dans le cadre d\'un contrat ou de votre côté. Vous aurez également besoin d\'assez de place dans votre inventaire pour un nouvel objet.";
		this.m.SuccessText = "[img]gfx/ui/events/event_81.png[/img]Alors que les %recently_destroyed% sont encore fumants dans votre sillage, un groupe de personnes sort de sa cachette dans un bosquet voisin où ils observaient la bataille de loin. Une vieille femme s\'approche de vous. %SPEECH_ON%Ces monstres à la peau verte nous ont chassés de notre ferme à l\'extérieur de %nearesttown%, mais grâce à vos vaillants compagnons, nous allons prospérer à nouveau. Ceci est pour vous.%SPEECH_OFF%Elle propose un sac de pommes. Bien que ce ne soit pas une grande récompense, ce sentiment sera répété encore et encore lorsque la nouvelle de la destruction des orcs se répandra. %highestexperience_brother% pousse un rire et mord dans une des pommes juteuses.%SPEECH_ON%Avec les orcs, les grands sont trop lents, et les jeunes trop stupides. La stratégie l\'emporte toujours sur la force brute. Les grandes bêtes vertes comptent sur la peur pour faire le travail à leur place. Tenez-vous bien et vous pourrez les battre comme n\'importe qui d\'autre !%SPEECH_OFF%Les paysans s\'émerveillent de la parole, des prouesses et de la force de %highestexperience_brother%, applaudissent, le couvrent de compliments et lui tapent dans le dos. Bien qu\'il s\'agisse certainement de paroles vraies, ce n\'est pas le public qui devrait mettre ces conseils en pratique. Vous posez votre main sur l\'épaule de %highestexperience_brother%, comme pour lui dire de baisser d\'un cran, de peur que les paysans ne se prennent pour des héros la prochaine fois qu\'ils aperçoivent une peau verte.";
		this.m.SuccessButtonText = "Dites à tout le monde que c\'est %companyname% qui a remporté la victoire ici !";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.m.Defeated + "/4)";
	}

	function onLocationDestroyed( _location )
	{
		if (this.World.FactionManager.getFaction(_location.getFaction()).getType() == this.Const.FactionType.Orcs)
		{
			++this.m.Defeated;
			this.World.Ambitions.updateUI();
		}
	}

	function onUpdateScore()
	{
		if (this.World.getTime().Days < 25)
		{
			return;
		}

		if (!this.World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone())
		{
			return;
		}

		this.m.Score = 2 + this.Math.rand(0, 5);
	}

	function onCheckSuccess()
	{
		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return false;
		}

		if (this.m.Defeated >= 4)
		{
			return true;
		}

		return false;
	}

	function onPrepareVariables( _vars )
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local fearful = [];
		local lowborn = [];

		if (brothers.len() > 1)
		{
			for( local i = 0; i < brothers.len(); i = ++i )
			{
				if (brothers[i].getSkills().hasSkill("trait.player"))
				{
					brothers.remove(i);
					break;
				}
			}
		}

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.superstitious"))
			{
				fearful.push(bro);
			}
			else if (bro.getBackground().isLowborn())
			{
				lowborn.push(bro);
			}
		}

		local fear;

		if (fearful.len() != 0)
		{
			fear = fearful[this.Math.rand(0, fearful.len() - 1)];
		}
		else if (lowborn.len() != 0)
		{
			fear = lowborn[this.Math.rand(0, lowborn.len() - 1)];
		}
		else
		{
			fear = brothers[this.Math.rand(0, brothers.len() - 1)];
		}

		_vars.push([
			"fearful_brother",
			fear.getName()
		]);
		_vars.push([
			"recently_destroyed",
			this.World.Statistics.getFlags().get("LastLocationDestroyedName")
		]);
	}

	function onReward()
	{
		local item;
		local stash = this.World.Assets.getStash();
		item = this.new("scripts/items/accessory/orc_trophy_item");
		stash.add(item);
		this.m.SuccessList.push({
			id = 10,
			icon = "ui/items/" + item.getIcon(),
			text = "Vous recevez " + this.Const.Strings.getArticle(item.getName()) + item.getName()
		});
	}

	function onSerialize( _out )
	{
		this.ambition.onSerialize(_out);
		_out.writeU8(this.m.Defeated);
	}

	function onDeserialize( _in )
	{
		this.ambition.onDeserialize(_in);
		this.m.Defeated = _in.readU8();
	}

});


this.defeat_undead_location_ambition <- this.inherit("scripts/ambitions/ambition", {
	m = {
		Defeated = 0
	},
	function create()
	{
		this.ambition.create();
		this.m.ID = "ambition.defeat_undead_location";
		this.m.Duration = 21.0 * this.World.getTime().SecondsPerDay;
		this.m.ButtonText = "Les morts-vivants sont une terrible malédiction pour l\'homme. Brûlons quelques-uns de leurs repaires et gagnons le respect de tous les honnêtes gens !";
		this.m.RewardTooltip = "Vous recevrez un accessoire unique qui double la détermination du porteur lorsqu\'il se défend contre les effets de la peur et du contrôle mental.";
		this.m.UIText = "Détruire les lieux assaillis par les morts-vivants";
		this.m.TooltipText = "Détruisez quatre lieux envahis de morts-vivants pour prouver les prouesses de la compagnie, que ce soit dans le cadre d\'un contrat ou par vous même. Vous aurez également besoin d\'assez de place dans votre inventaire pour un nouvel objet.";
		this.m.SuccessText = "[img]gfx/ui/events/event_46.png[/img]Grâce à %companyname%, les monstruosités ambulantes de %recently_destroyed% ne menaceront plus jamais les innocents. Les hommes, cependant, auront besoin de quelques jours, et de beaucoup de boissons, pour assimiler les horreurs qu\'ils ont affrontées.%SPEECH_ON% Comment une chose aussi immonde peut-elle se montrer à la lumière du jour ? %SPEECH_OFF% demande %randombrother%, en regardant fadement au loin.%SPEECH_ON% Il s\'est effondré en un tas d\'os pourris et de poussière. Rien ne le maintenait en un seul morceau à par sa malédiction.%SPEECH_OFF%Des peurs encore plus sombres sont réveillés chez %fearful_brother%.%SPEECH_ON%On m\'a dit à %randomtown% que tout homme bon tué par l\'une de ces horreurs est condamné à revenir de la tombe lui-même et ne peut jamais s\'asseoir auprès des dieux.%SPEECH_OFF%Certains hommes s\'opposent bruyamment à cela, non pas parce qu\'ils savent mieux, mais parce qu\'ils ne veulent pas que ce soit vrai. Vous donnez l\'ordre d\'éteindre le feu avant que quelqu\'un ne commence à raconter d\'autres histoires de fantômes. Les hommes auront peut-être du mal à dormir cette nuit, mais le moral remontera avec l\'aube.";
		this.m.SuccessButtonText = "Quoi qu\'il en soit, nous sommes à nouveau victorieux !";
	}

	function getUIText()
	{
		return this.m.UIText + " (" + this.m.Defeated + "/4)";
	}

	function onLocationDestroyed( _location )
	{
		if (this.World.FactionManager.getFaction(_location.getFaction()).getType() == this.Const.FactionType.Undead || this.World.FactionManager.getFaction(_location.getFaction()).getType() == this.Const.FactionType.Zombies)
		{
			++this.m.Defeated;
			this.World.Ambitions.updateUI();
		}
	}

	function onUpdateScore()
	{
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
		item = this.new("scripts/items/accessory/undead_trophy_item");
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


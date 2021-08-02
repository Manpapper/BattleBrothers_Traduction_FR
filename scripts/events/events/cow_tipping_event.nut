this.cow_tipping_event <- this.inherit("scripts/events/event", {
	m = {
		Other = null,
		Strong = null,
		Cocky = null
	},
	function create()
	{
		this.m.ID = "event.cow_tipping";
		this.m.Title = "Sur la route...";
		this.m.Cooldown = 99999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_72.png[/img]Alors que vous marchez, vous croisez une vache solitaire dans un champ. Il n'y a pas grand chose à en dire : c'est juste une vache. Mais c'est alors que %randombrother% s'approche de vous, en rongeant un morceau de paille et en le faisant tourner en rond tout en parlant.%SPEECH_ON%Alors, qui peut le faire, à votre avis ?%SPEECH_OFF%Vous demandez \'Faire quoi?\' il sourit.%SPEECH_ON%Oh, désolé, Cap'. Je n'avais pas réalisé que vous n'aviez pas entendu. Nous allons voir si quelqu'un peut faire tomber cette vache ! Vu qu'on ne peut la renverser qu'une fois, pourquoi ne pas choisir lequel d'entre nous va essayer en premier ?%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [],
			function start( _event )
			{
				this.Options.push({
					Text = "Choisissez celui que vous pensez être le meilleur.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 50 ? "B" : "C";
					}

				});

				if (_event.m.Strong != null)
				{
					this.Options.push({
						Text = "Je parie que %strong% est assez fort pour le faire.",
						function getResult( _event )
						{
							return "Strong";
						}

					});
				}

				if (_event.m.Cocky != null)
				{
					this.Options.push({
						Text = "Ce bâtard arrogant, %cocky%, a l'air d'avoir envie d'y aller.",
						function getResult( _event )
						{
							return "Cocky";
						}

					});
				}

				this.Options.push({
					Text = "Laissez cette vache tranquille.",
					function getResult( _event )
					{
						return 0;
					}

				});
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_72.png[/img]Vous dites aux hommes de se débrouiller eux-mêmes. Ils choisissent rapidement %cowtipper% qui, après avoir été intimidé, accepte de tenter le coup.\n\nLe mercenaire traverse prudemment le champ, en faisant de son mieux pour éviter les bouses de vache. La vache elle-même regarde nonchalamment. Elle mugit une fois avant de reporter son attention de petit bovin sur l'herbe. En ricanant, les hommes poussent %cowtipper% vers l'avant, en lui disant \"fais-le !\" et \"qu'est-ce que tu attends ?\" Finalement, à quelques mètres de la vache, %cowtipper% charge.%SPEECH_ON%Yaaahh!%SPEECH_OFF%Il fonce dans le flanc de la vache et c'est comme s'il avait foncé dans une maison : ses pieds se dérobent sous lui et il dérape sous l'animal, un glissement bien huilé par la merde fraîche. La compagnie éclate de rire.%SPEECH_ON%Tu ne peux pas faire basculer une vache, imbécile ! Elles sont trop lourdes, putain !%SPEECH_OFF% %cowtipper% a sans doute une nouvelle dent contre ces rigolos, mais son \"sacrifice\" valait bien ce divertissement.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Quel spectacle!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				_event.m.Other.worsenMood(0.5, "S'est humilié devant la compagnie");

				if (_event.m.Other.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Other.getMoodState()],
						text = _event.m.Other.getName() + this.Const.MoodStateEvent[_event.m.Other.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Other.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(0.5, "Amusé par la tentative de " + _event.m.Other.getName() + " de renverser une vache");

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_72.png[/img]Vous dites aux hommes de se débrouiller seuls. Ils choisissent rapidement %cowtipper%. Le mercenaire traverse le champ avec précaution, en faisant de son mieux pour éviter les bouses de vache. La vache elle-même regarde nonchalamment par-dessus et mugit une fois avant de retourner son attention à l'herbe. En ricanant, les hommes poussent %cowtipper% vers l'avant, en lui disant : \"fais-le !\" et \"dépêche-toi maintenant !\". Enfin, se tenant à quelques mètres de la vache, %cowtipper% charge en avant.%SPEECH_ON%Yaaahh!%SPEECH_OFF%Le cri effraie la vache. Elle se penche en avant et donne un coup de sabot, attrapant %cowtipper% avec un bout de sabot. Il tourne violemment sur ses pieds et s'écrase dans l'herbe. Les hommes rient un instant, puis réalisent que c'est sérieux. Alors que la vache meugle et s'éloigne au trot, le mercenaire est \"sauvé\". Bien que gravement blessé, il survivra à ce quasi homicide bovin.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "La fête est terminée.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Other.getImagePath());
				local injury = _event.m.Other.addInjury(this.Const.Injury.Accident3);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Other.getName() + " souffre de " + injury.getNameOnly()
				});
				_event.m.Other.worsenMood(0.5, "S'est humilié devant la compagnie");

				if (_event.m.Other.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Other.getMoodState()],
						text = _event.m.Other.getName() + this.Const.MoodStateEvent[_event.m.Other.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "Strong",
			Text = "[img]gfx/ui/events/event_72.png[/img]Vous pensez que %strong%, fort et costaud, pourrait donner un bon coup à la vache. Votre formulation maladroite fait rire les hommes, mais %strong% s'incline respectueusement.%SPEECH_ON%Je suis honoré, boss.%SPEECH_OFF%Il retrousse ses manches et traverse le champ, enjambant les bouses de vache comme un enfant jouant à le sol est de la lave. La vache le regarde, levant un sourcil curieux. %strong% hoche la tête.%SPEECH_ON%C'est ça, j'arrive.%SPEECH_OFF%D'autres problèmes de formulation apparaissent. Malgré les rires de la compagnie, %strong% charge la vache. Au début, il se contente de s'appuyer contre son flanc, musclé et haletant. Les hommes rient alors que ses efforts ne mènent nulle part, mais ils se calment rapidement lorsque la vache glisse sur la boue et l'herbe. Avec un puissant rugissement, %strong% s'élance en avant et la vache tombe sur le côté avec un meuglement confus.\n\n %otherbrother% se tient là, bouche bée.%SPEECH_ON%C'était une blague... Je ne pensais pas que c'était réellement possible...%SPEECH_OFF%La compagnie applaudit à tout va la performance incroyable de cet homme!",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bien Joué!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Strong.getImagePath());
				_event.m.Strong.getBaseProperties().Stamina += 1;
				_event.m.Strong.getSkills().update();
				this.List.push({
					id = 17,
					icon = "ui/icons/fatigue.png",
					text = _event.m.Strong.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] de Fatigue Maximum"
				});
				_event.m.Strong.improveMood(0.5, "A montré ses prouesses physiques");

				if (_event.m.Other.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Strong.getMoodState()],
						text = _event.m.Strong.getName() + this.Const.MoodStateEvent[_event.m.Strong.getMoodState()]
					});
				}

				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Strong.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(0.5, "A été témoin de l'exploit incroyable de " + _event.m.Strong.getName());

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
		this.m.Screens.push({
			ID = "Cocky",
			Text = "[img]gfx/ui/events/event_72.png[/img]Avant même que vous ne puissiez finir votre phrase, %cocky% se frappe la poitrine et s'avance.%SPEECH_ON%Je vais abattre cette vache mesquine !%SPEECH_OFF%Vous lui rappelez que la compagnie n'a rien contre cette créature bovine et que tout ceci n'est qu'un jeu. Il reste là, les bras en croix, les poings sur les hanches.%SPEECH_OFF%Le mercenaire sur de lui entre dans le champ et marche immédiatement sur une bouse de vache. Il se déplace en avant, les bras en l'air pour trouver l'équilibre, mais c'est en vain qu'il s'écrase sur le sol. Les hommes éclatent de rire. La vache jette un coup d'œil avant de s'en aller. %cocky% se nettoie.%SPEECH_ON%Un petit faux pas. Mais regardez ! Cette vache trouillarde ne veut rien savoir de moi !%SPEECH_OFF%%otherbrother% rit et montre du doigt les vêtements tachés du mercenaire.%SPEECH_ON%Peut-être, mais on dirait que tu as une petite partie d'elle.%SPEECH_OFF%L'arrogant mercenaire enlève rapidement la merde de sa chemise. Malgré l'échec, il ne se décourage pas et les hommes manquent de s'évanouir tellement ils rient.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ça aurait pu être pire.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cocky.getImagePath());
				_event.m.Cocky.getBaseProperties().Bravery += 1;
				_event.m.Cocky.getSkills().update();
				this.List.push({
					id = 17,
					icon = "ui/icons/bravery.png",
					text = _event.m.Cocky.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+1[/color] de Détermination"
				});
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.Cocky.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 50)
					{
						bro.improveMood(0.5, "A été témoin de l'échec incroyable de" + _event.m.Cocky.getName());

						if (bro.getMoodState() >= this.Const.MoodState.Neutral)
						{
							this.List.push({
								id = 10,
								icon = this.Const.MoodStateIcon[bro.getMoodState()],
								text = bro.getName() + this.Const.MoodStateEvent[bro.getMoodState()]
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type != this.Const.World.TerrainType.Plains && currentTile.Type != this.Const.World.TerrainType.Steppe)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidate_strong = [];
		local candidate_cocky = [];
		local candidate_other = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.strong") || bro.getSkills().hasSkill("trait.tough"))
			{
				candidate_strong.push(bro);
			}
			else if (bro.getSkills().hasSkill("trait.cocky"))
			{
				candidate_cocky.push(bro);
			}
			else
			{
				candidate_other.push(bro);
			}
		}

		if (candidate_other.len() == 0)
		{
			return;
		}

		if (candidate_strong.len() != 0)
		{
			this.m.Strong = candidate_strong[this.Math.rand(0, candidate_strong.len() - 1)];
		}

		if (candidate_cocky.len() != 0)
		{
			this.m.Cocky = candidate_cocky[this.Math.rand(0, candidate_cocky.len() - 1)];
		}

		this.m.Other = candidate_other[this.Math.rand(0, candidate_other.len() - 1)];
		this.m.Score = 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"strong",
			this.m.Strong != null ? this.m.Strong.getNameOnly() : ""
		]);
		_vars.push([
			"strongfull",
			this.m.Strong != null ? this.m.Strong.getName() : ""
		]);
		_vars.push([
			"cocky",
			this.m.Cocky != null ? this.m.Cocky.getNameOnly() : ""
		]);
		_vars.push([
			"cockyfull",
			this.m.Cocky != null ? this.m.Cocky.getName() : ""
		]);
		_vars.push([
			"cowtipper",
			this.m.Other != null ? this.m.Other.getNameOnly() : ""
		]);
		_vars.push([
			"cowtipperfull",
			this.m.Other != null ? this.m.Other.getName() : ""
		]);
		_vars.push([
			"otherbrother",
			this.m.Other != null ? this.m.Other.getName() : ""
		]);
	}

	function onClear()
	{
		this.m.Strong = null;
		this.m.Cocky = null;
		this.m.Other = null;
	}

});


this.hedge_knight_vs_refugee_event <- this.inherit("scripts/events/event", {
	m = {
		HedgeKnight = null,
		Refugee = null,
		OtherGuy = null
	},
	function create()
	{
		this.m.ID = "event.hedge_knight_vs_refugee";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 60.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_52.png[/img]%hedgeknight%, le chevalier errant, marche vers un %refugee% qui mange. Il voit l\'ombre se profiler au-dessus de lui et se retourne lentement.%SPEECH_ON%Ouais?%SPEECH_OFF%Le chevalier errant renifle et crache un mollard de la taille du bras d\'un bébé. Il renifle encore.%SPEECH_ON%Vous avez fui votre maison. Vous l\'avez regardé brûler et avez fermer les yeux sur les flammes plutôt que de les affronter. Cette compagnie est votre maison maintenant. Qu\'est-ce qui vous empêche de fuir le feu maintenant?%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Allez, %hedgeknight%. Arrêtez ça!",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Vous pouvez vous en occuper vous-mêmes.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight.getImagePath());
				this.Characters.push(_event.m.Refugee.getImagePath());

				if (_event.m.OtherGuy != null)
				{
					this.Options.push({
						Text = "Attends. %streetrat%, on dirait que vous avez quelque chose à dire?",
						function getResult( _event )
						{
							return "D";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_52.png[/img]Vous vous avancez et vous dites au chevalier errant de se la fermer. L\'entreprise n\'est pas là pour flatter son ego. En riant, l\'armoire à glace s\'éloigne.%SPEECH_ON%Comme vous le dites, monsieur. Je ne voudrais pas m\'embrouiller avec la princesse de la compagnie.%SPEECH_OFF%La compagnie rit, mais le réfugié se contente de fixer son bol de nourriture comme si quelqu\'un venait de cracher dedans.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Eh bien, je suppose que c\'est réglé.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight.getImagePath());
				this.Characters.push(_event.m.Refugee.getImagePath());
				local bravery = this.Math.rand(1, 3);
				_event.m.Refugee.getBaseProperties().Bravery -= bravery;
				_event.m.Refugee.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Refugee.getName() + " loses [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + bravery + "[/color] Resolve"
				});
				_event.m.Refugee.worsenMood(1.0, "Got humiliated in front of the company");

				if (_event.m.Refugee.getMoodState() <= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Refugee.getMoodState()],
						text = _event.m.Refugee.getName() + this.Const.MoodStateEvent[_event.m.Refugee.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_06.png[/img]Vous n\'intervenez pas. Le chevalier errant continue.%SPEECH_ON%Je n\'ai aucune pitié pour votre souffrance. Vous comprenez?%SPEECH_OFF%En hochant la tête, le réfugié lève les yeux.%SPEECH_ON%Oui, mais quelle pitié a-t-on pour les vôtres?%SPEECH_OFF%Le bras du réfugié s\'avance si vite qu\'il renverse l\'assiette dans le feu de camp. La fourchette se plante dans la cuisse de %hedgeknight% et %refugee% ne peut pas l\'enlever plus facilement que si elle était plantée dans un chêne. Le chevalier errant grogne, tombe sur le réfugié et l\'aplatit. Ses mains géantes enfoncent le crâne du réfugié dans le sol jusqu\'à ce que le pauvre homme ne respire plus que de la terre. Le reste de la compagnie se lève et recule. Vous faites un pas en avant, mais %hedgeknight% vous tend la main avant de se relever.%SPEECH_ON%D\'accord, d\'accord. Tu as encore de la force en toi.%SPEECH_OFF%Il récupère la fourchette et la tend. Une goutte de sang s\'écoule entre ses dents.%SPEECH_ON%Qu\'est-ce que tu manges? Ah oui? Bien. Je vais le doubler avec ma portion. Viens t\'asseoir.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Content que ce soit réglé.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight.getImagePath());
				this.Characters.push(_event.m.Refugee.getImagePath());
				local bravery = this.Math.rand(1, 3);
				_event.m.Refugee.getBaseProperties().Bravery += bravery;
				_event.m.Refugee.getSkills().update();
				this.List.push({
					id = 16,
					icon = "ui/icons/bravery.png",
					text = _event.m.Refugee.getName() + " gagne [color=" + this.Const.UI.Color.PositiveEventValue + "]+" + bravery + "[/color] Resolve"
				});
				_event.m.Refugee.improveMood(1.0, "Got some recognition from " + _event.m.HedgeKnight.getName());

				if (_event.m.Refugee.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Refugee.getMoodState()],
						text = _event.m.Refugee.getName() + this.Const.MoodStateEvent[_event.m.Refugee.getMoodState()]
					});
				}

				_event.m.HedgeKnight.improveMood(0.5, "Grew to like " + _event.m.Refugee.getName() + " some");

				if (_event.m.HedgeKnight.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.HedgeKnight.getMoodState()],
						text = _event.m.HedgeKnight.getName() + this.Const.MoodStateEvent[_event.m.HedgeKnight.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_80.png[/img]%streetrat% s\'avance. Il pointe un doigt vers le chevalier errant.%SPEECH_ON%Vous n\'avez pas la moindre idée de ce qu\'est une flamme ou le feu.%SPEECH_OFF%En riant, %hedgeknight% se retourne et fait craquer ses doigts.%SPEECH_ON%Bien sûr que si. JE SUIS le feu.%SPEECH_OFF%Le roturier croise les bras de manière provocante.%SPEECH_ON%Et nous ne sommes pas le frêne, mais le bois lui-même. Tu es une putain pour les nobles, c\'est ce que tu es vraiment. Ils te paient un prix élevé et tu continues avec ta force et ta cruauté et tu fais ce qu\'ils te disent de faire. Comme... comme une putain...%SPEECH_OFF%Un autre mercenaire lève un doigt.%SPEECH_ON%Je pense que vous nous décrivez en général. Nous sommes des mercenaires.%SPEECH_OFF%Et un autre ajoute.%SPEECH_ON%Est-ce que vous venez de vous comparer à du petit bois?%SPEECH_OFF%%streetrat% se frotte l\'arrière de la tête.%SPEECH_ON%Ouais, je vais être honnête, le chevalier errant m\'a fait un peu peur et je ne sais plus ce que je voulais dire.%SPEECH_OFF%La compagnie regarde autour d\'elle avant d\'éclater de rire et l\'animosité qu\'il y avait a été balayée.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Pourquoi on se disputait déjà ?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.HedgeKnight.getImagePath());
				this.Characters.push(_event.m.OtherGuy.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getID() == _event.m.OtherGuy.getID() || bro.getID() == _event.m.HedgeKnight.getID())
					{
						continue;
					}

					if (this.Math.rand(1, 100) <= 25)
					{
						bro.improveMood(1.0, "Felt entertained");

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
		if (!this.Const.DLC.Unhold)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 2)
		{
			return;
		}

		local hedge_knight_candidates = [];
		local refugee_candidates = [];
		local other_candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getSkills().hasSkill("trait.player"))
			{
				continue;
			}

			if (bro.getBackground().getID() == "background.hedge_knight")
			{
				hedge_knight_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.refugee")
			{
				refugee_candidates.push(bro);
			}
			else if (bro.getBackground().getID() == "background.vagabond" || bro.getBackground().getID() == "background.beggar" || bro.getBackground().getID() == "background.cripple" || bro.getBackground().getID() == "background.servant" || bro.getBackground().getID() == "background.ratcatcher")
			{
				other_candidates.push(bro);
			}
		}

		if (hedge_knight_candidates.len() == 0 || refugee_candidates.len() == 0)
		{
			return;
		}

		this.m.HedgeKnight = hedge_knight_candidates[this.Math.rand(0, hedge_knight_candidates.len() - 1)];
		this.m.Refugee = refugee_candidates[this.Math.rand(0, refugee_candidates.len() - 1)];
		this.m.Score = (hedge_knight_candidates.len() + refugee_candidates.len()) * 5;

		if (other_candidates.len() != 0)
		{
			this.m.OtherGuy = other_candidates[this.Math.rand(0, other_candidates.len() - 1)];
		}
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"hedgeknight",
			this.m.HedgeKnight.getNameOnly()
		]);
		_vars.push([
			"refugee",
			this.m.Refugee.getName()
		]);
		_vars.push([
			"streetrat",
			this.m.OtherGuy != null ? this.m.OtherGuy.getName() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.HedgeKnight = null;
		this.m.Refugee = null;
		this.m.OtherGuy = null;
	}

});


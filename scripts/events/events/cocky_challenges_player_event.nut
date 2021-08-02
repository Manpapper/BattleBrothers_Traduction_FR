this.cocky_challenges_player_event <- this.inherit("scripts/events/event", {
	m = {
		Cocky = null
	},
	function create()
	{
		this.m.ID = "event.cocky_challenges_player";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 45.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_26.png[/img]Alors que vous rejoignez la compagnie autour du feu de camp, %cocky% se lève et parle le visage rougi.%SPEECH_ON%Je ne sais pas pour le reste d\'entre vous, tristes bougres, mais je pense que je pourrais diriger ce camp mieux que quiconque ! Surtout mieux que lui !%SPEECH_OFF%Il pointe un doigt vers vous.\n\nVous prenez un siège. Les hommes vous fixent, attendant une réponse.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tu as tout à fait raison. C\'est toi qui devrais être responsable.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Il est temps de te remettre à ta place.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "C\'est moi qui commande ici ! C\'est ma compagnie !",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cocky.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_26.png[/img]Vous bougez vos pieds, les jambes écartées, et placez vos mains sur vos genoux. En hochant la tête, vous vous adressez à l\'homme.%SPEECH_ON%D\'accord, %cocky%. C\'est toi l\'homme maintenant. Tu devras faire l\'inventaire chaque matin et chaque soir. Je sais que tu ne sais pas compter, mais tu apprendras. Je ne veux pas que ces hommes aillent au combat avec quelques flèches en moins.%SPEECH_OFF%Vous faites signe de la main vers les tentes.%SPEECH_ON%Tu devras aussi garder un oeil sur les hommes. Ils ne sont pas faciles à contrôler, ce qui peut être ironique, ou pas.%SPEECH_OFF%En regardant vos mains, qui sont devenues calleuses et meurtries au fil des années, vous continuez à parler.%SPEECH_ON%Et tu devras aboyer des ordres qui ne sont pas seulement là pour être entendus, mais aussi pour garder les hommes en vie et les faire continuer de respirer. Tu sais, comme toi-même et ceux qui sont assis autour de vous. Alors ouais, prends le job, %cocky%. Il est tout à toi.%SPEECH_OFF%Dès que tu as terminé, un groupe de frères d\'armes se lève immédiatement et te supplie de rester aux commandes. %cocky%, voyant cela, recule et s\'éloigne alors que les cris de \"C\'est toi le chef !\" remplissent l\'air.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Vous avez bien raison.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cocky.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (bro.getMoodState() < this.Const.MoodState.Neutral && this.Math.rand(1, 100) <= 33)
					{
						bro.improveMood(1.0, "Confiance accrue en votre leadership");

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
			Text = "[img]gfx/ui/events/event_26.png[/img]Le feu de camp crépite et l\'on peut apercevoir une lueur orange sur votre visage. En hochant la tête, vous vous levez et vous vous dirigez vers %cocky%. Il recule d\'un pas, mais pas avant que vous ne lanciez une main pour l\'attraper par l\'épaule. Vous vous avancez rapidement, donnant un coup de pied derrière son genou, le faisant plier et le projetant sur le dos. Vous le suivez au sol et plantez une main autour de sa gorge tandis que l\'autre pointe un doigt accusateur.%SPEECH_ON%Tu es un homme bon %cocky%, mais aussi un homme stupide. Maintenant, je vois que certains d\'entre vous ne sont pas contents de la façon dont les choses se passent, mais laissez-moi vous rappeler que vous êtes tous encore en vie ! Si quelqu\'un comme %cocky% était aux commandes, vous seriez tous morts en quinze jours !%SPEECH_OFF%En vous levant, vous aidez %cocky% à se relever. Il ricane et s\'en va, renversant une pile de tonneaux en partant. Une vague de douleur s\'échappe de l\'endroit où la flèche vous a touché il n\'y a pas longtemps, mais vous serrez les dents et essayez de ne rien laisser paraître en vous rasseyant.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Je l\'ai toujours !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cocky.getImagePath());
				_event.m.Cocky.worsenMood(3.0, "S\'est fait humilié devant toute la compagnie");
				this.List.push({
					id = 10,
					icon = this.Const.MoodStateIcon[_event.m.Cocky.getMoodState()],
					text = _event.m.Cocky.getName() + this.Const.MoodStateEvent[_event.m.Cocky.getMoodState()]
				});
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_26.png[/img]Vous vous remettez immédiatement sur vos pieds et commencez à crier.%SPEECH_ON%C\'est moi qui commande ici ! Moi ! Qui a l\'argent ? Moi ! Si ce n\'était pas pour moi, aucun de vous ne serait ici ! Vous seriez encore dans les trous d\'où je vous ais sauvés ! Vous devriez ramper à mes pieds pour les opportunités que je vous ai offertes ! Et %cocky%, si tu me contestes encore, je jure devant les dieux que je te ferai fouetter et pendre, compris ?%SPEECH_OFF%Cet explosion de rage fait instantanément taire le camp. %cocky% acquiesce et se retire. Quelques hommes murmurent entre eux tandis que vous reprenez votre place.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Ça s\'est plutôt bien passé, non ?",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Cocky.getImagePath());
				local brothers = this.World.getPlayerRoster().getAll();

				foreach( bro in brothers )
				{
					if (this.Math.rand(1, 100) <= 33)
					{
						bro.worsenMood(1.0, "Perd confiance en votre leadership");

						if (bro.getMoodState() < this.Const.MoodState.Neutral)
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
		if (this.World.getTime().IsDaytime)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];
		local grumpy = 0;

		foreach( bro in brothers )
		{
			if (bro.getMoodState() < this.Const.MoodState.Neutral)
			{
				grumpy = ++grumpy;

				if (bro.getSkills().hasSkill("trait.cocky"))
				{
					candidates.push(bro);
				}
			}
		}

		if (candidates.len() == 0 || grumpy < 3)
		{
			return;
		}

		this.m.Cocky = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 3 + grumpy * 3;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"cocky",
			this.m.Cocky.getName()
		]);
	}

	function onClear()
	{
		this.m.Cocky = null;
	}

});


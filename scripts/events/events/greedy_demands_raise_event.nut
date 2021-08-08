this.greedy_demands_raise_event <- this.inherit("scripts/events/event", {
	m = {
		Greedy = null
	},
	function create()
	{
		this.m.ID = "event.greedy_demands_raise";
		this.m.Title = "Pendant le camp...";
		this.m.Cooldown = 40.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_64.png[/img]{%bro% entre dans votre tente avec un parchemin à ses côtés. Il le déplie, révélant une contenant littérallement tous ce qu\'il a tué. Vous lui demandez ce qu\'il veut que vous fassiez avec ça. Le parchemin est jeté sur votre bureau et il vous répond.%SPEECH_ON%Compensez-moi. Un salaire plus élevé dès maintenant. %newpay% couronnes par jour.%SPEECH_OFF% | %bro% souhaite apparemment être mieux payé, %newpay% couronnes par jour au lieu des %oldpay% couronnes qu\'il gagne actuellement, affirmant qu\'il a tué un grand nombre d\'ennemis en faisant partie de %companyname%.\n\nTuer beaucoup de choses est une bonne monnaie d\'échange quand c\'est le domaine dans lequel vous êtes, vous lui accorderez ça. | Il semble que %bro% veuille être payé davantage pour avoir tué beaucoup de, eh bien, tout en votre nom. Vous lui dites que rien de tout cela n\'a été fait en votre nom personnel, mais que vous l\'avez simplement payé pour le faire. Il acquiesce.%SPEECH_ON%C\'est vrai. Et maintenant je veux être payé plus. %newpay% couronnes par jour.%SPEECH_OFF% | %bro% a l\'impression que ses services pour la compagnie ne sont pas bien rémunérés. Il demande à être mieux payé, %newpay% de couronnes par jour au lieu des %oldpay% de couronnes qu\'il gagne actuellement, en raison de ses compétences en tant que mercenaire. | %bro% exige que vous le payiez davantage, %newpay% couronnes par jour au lieu du %oldpay% couronnes qu\'il a gagné jusqu\'à présent, maintenant qu\'il a prouvé qu\'il était plus que capable de se battre pour %companyname%.\n\nIl a raison, mais vous n\'êtes pas encore sûr d\'être prêt à remettre les couronnes.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Très bien, tu l\'as mérité.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Tu auras ce que nous avons convenu et rien de plus.",
					function getResult( _event )
					{
						return "C";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Greedy.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_64.png[/img]{Vous acceptez les conditions de %bro%. Sans surprise, il en est heureux et vous continuez votre journée. | Les exigences de %bro% ne sont pas trop élevées et vous êtes heureux de lui donner quelques couronnes supplémentaires par jour. Il vous donne une poignée de main. C\'est ferme, mais pas trop. | %bro% vacille sur ses pieds alors qu\'il se prépare à votre réponse. Vous lui dites de se détendre car vous avez accepté ses conditions. Il soupire finalement de soulagement.%SPEECH_ON%Merci, monsieur. Je pensais que je devrais peut-être, je ne sais pas.%SPEECH_OFF%Vous levez un sourcil.%SPEECH_ON%J\'espère que ce n\'était pas une menace.%SPEECH_OFF%L\'homme rit maladroitement et secoue la tête.%SPEECH_ON%Non, non, bien sûr que non !%SPEECH_OFF% | Vous dites à %bro% que vous augmenterez son salaire à une condition : qu\'il fasse une petite danse.%SPEECH_ON%Une danse de la victoire ?%SPEECH_OFF%Vous haussez les épaules.%SPEECH_ON%N\'importe quelle danse.%SPEECH_OFF%Il lève les bras et les balance un peu. Vous éclatez de rire.%SPEECH_ON%Aucun nombre de meurtres n\'équivaudrait à ce que c\'était.%SPEECH_OFF%L\'homme ricane.%SPEECH_ON%Merci, monsieur.%SPEECH_OFF% | Vous acceptez de donner à %bro% un salaire plus élevé.%SPEECH_ON%C\'était mon honneur.%SPEECH_OFF%L\'homme lève un sourcil.%SPEECH_ON%Epargnez-moi la cérémonie. Je suis ici pour tuer, ne tournons pas autour du pot.%SPEECH_OFF%Vous acquiescez.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Tu l\'as mérité !",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Greedy.getImagePath());
				_event.m.Greedy.getBaseProperties().DailyWage += 8;
				_event.m.Greedy.improveMood(2.0, "a reçu une augmentation de salaire");
				_event.m.Greedy.getSkills().update();
				this.List.push({
					id = 10,
					icon = "ui/icons/asset_daily_money.png",
					text = _event.m.Greedy.getName() + " est maintenant payé " + _event.m.Greedy.getDailyCost() + " Couronnes par jour"
				});

				if (_event.m.Greedy.getMoodState() >= this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Greedy.getMoodState()],
						text = _event.m.Greedy.getName() + this.Const.MoodStateEvent[_event.m.Greedy.getMoodState()]
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_64.png[/img]{Vous refusez la demande de %bro%. Il pince les lèvres, se tord les mains, puis acquiesce, se tourne et part. Le silence est un peu dur, mais le message est bien reçu : ce n\'est pas un homme heureux. | Décliner la demande de %bro% ce qui mène à une explosion soudaine.%SPEECH_ON%Eh bien, putain de merde. Je me battrai toujours pour vous, mais n\'attendez pas le meilleur de moi !%SPEECH_OFF%Vous acquiescez, mais lui dites qu\'il mourra sans avoir donné le meilleur de lui-même, donc vous obtiendrez ce que vous voulez de toute façon. | %bro% grimace lorsque vous refusez la suggestion.%SPEECH_ON%Très bien alors, je vois comment cet endroit est géré. On entre, on sort. Ça n\'a pas d\'importance pour toi, hein ? Nous sommes juste les pions que vous utilisez pour obtenir ce que vous voulez. C\'est bien. C\'est absolument parfait.%SPEECH_OFF%Il se retourne et part. Vous avez l\'impression que tout ne va pas \"Parfaitement Bien\". | Vous dites à %bro% que vous n\'êtes pas d\'accord avec ses estimations sur le montant de son salaire. Il répond par quelques jurons dont le volume est estimé à \"fort\". Lorsqu\'il a terminé, il hoche la tête.%SPEECH_ON%Mais ça va. Je comprends le boulot. Et je suis sûr que vous comprenez que je dois aussi m\'occuper du boulot qu\'est moi même.%SPEECH_OFF% | %bro% fait pression pour plus de salaire, mais vous mettez votre pied à terre.%SPEECH_ON%Vous aurez ce que nous avons convenu, pas plus.%SPEECH_OFF%Il acquiesce et sort lentement de la tente.%SPEECH_ON%Comme vous le voulez, boss.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "On ne peut pas toujours avoir ce qu\'on veut.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Greedy.getImagePath());
				_event.m.Greedy.worsenMood(this.Math.rand(2, 3), "On lui a refusé une augmentation de salaire");

				if (_event.m.Greedy.getMoodState() < this.Const.MoodState.Neutral)
				{
					this.List.push({
						id = 10,
						icon = this.Const.MoodStateIcon[_event.m.Greedy.getMoodState()],
						text = _event.m.Greedy.getName() + this.Const.MoodStateEvent[_event.m.Greedy.getMoodState()]
					});

					if (_event.m.Greedy.getMoodState() == this.Const.MoodState.Angry)
					{
						if (!_event.m.Greedy.getSkills().hasSkill("trait.loyal") && !_event.m.Greedy.getSkills().hasSkill("trait.disloyal"))
						{
							local trait = this.new("scripts/skills/traits/disloyal_trait");
							_event.m.Greedy.getSkills().add(trait);
							this.List.push({
								id = 10,
								icon = trait.getIcon(),
								text = _event.m.Greedy.getName() + " devient déloyal"
							});
						}
						else if (_event.m.Greedy.getSkills().hasSkill("trait.loyal"))
						{
							_event.m.Greedy.getSkills().removeByID("trait.loyal");
							this.List.push({
								id = 10,
								icon = "ui/traits/trait_icon_39.png",
								text = _event.m.Greedy.getName() + " n\'est plus loyal"
							});
						}
					}
				}
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Retinue.hasFollower("follower.paymaster"))
		{
			return;
		}

		if (this.World.Assets.getMoney() < 4000)
		{
			return;
		}

		local brothers = this.World.getPlayerRoster().getAll();

		if (brothers.len() < 3)
		{
			return;
		}

		local candidates = [];

		foreach( bro in brothers )
		{
			if (bro.getLevel() < 8)
			{
				continue;
			}

			if (bro.getSkills().hasSkill("trait.greedy"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() == 0)
		{
			return;
		}

		this.m.Greedy = candidates[this.Math.rand(0, candidates.len() - 1)];
		this.m.Score = candidates.len() * 5;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"bro",
			this.m.Greedy.getName()
		]);
		_vars.push([
			"oldpay",
			this.m.Greedy.getDailyCost()
		]);
		_vars.push([
			"newpay",
			this.m.Greedy.getDailyCost() + 8
		]);
	}

	function onClear()
	{
		this.m.Greedy = null;
	}

});


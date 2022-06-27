this.golden_goose_event <- this.inherit("scripts/events/event", {
	m = {
		Observer = null
	},
	function create()
	{
		this.m.ID = "event.location.golden_goose";
		this.m.Title = "En approchant...";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_125.png[/img]{Le navire a fait naufrage au milieu des arbres, dont certains ont depuis longtemps commencé à pousser au travers. Pour autant que vous le sachiez, il n\'y a ni mer ni rivière à des kilomètres à la ronde. %observer% s\'avance et s\'arrête devant ce spectacle.%SPEECH_ON%Par les vieux dieux, est-ce un bateau?%SPEECH_OFF%Vous soupirez et dites à toute la compagnie de rester ici pendant que vous et %observer% allez jeter un coup d\'œil.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Voyons voir quels secrets se cachent à l\'intérieur.",
					function getResult( _event )
					{
						return "B";
					}

				},
				{
					Text = "Ce n\'est pas la peine d\enquêter maintenant.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Observer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_125.png[/img]{Vous entrez dans les entrailles du vaisseau. C\'est complètement vide, à l\'exception d\'une souche dans laquelle est planté un manche de hache. %observer% le regarde.%SPEECH_ON%Il y a un manche de hache.%SPEECH_OFF%En hochant la tête, vous dites que c\'est bien ça. Mais le manche en métal porte des traces de teinte dorée. En vous rapprochant de la souche, vous pouvez voir des braises qui s\'élèvent du morceau de metal. %observer% vous tape sur l\'épaule et vous le voyez pointer du doigt un coin sombre du vaisseau.%SPEECH_ON%Un squelette. Mort.%SPEECH_OFF%Vous apercevez à peine ses ossements pâles. En vous approchant, les vêtements deviennent apparents, il s\'agit bien d\'une tenue royale. Il y a une corne à boire dans une main et une miche de pain moisi dans l\'autre. Sa veste est éventrée et déchiquetée par des éclats. En regardant de plus près, une partie du bois est incrustée dans son cerveau.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Inspectez la souche.",
					function getResult( _event )
					{
						return "C";
					}

				},
				{
					Text = "Allons-nous-en d\'ici.",
					function getResult( _event )
					{
						if (this.World.State.getLastLocation() != null)
						{
							this.World.State.getLastLocation().setVisited(false);
						}

						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Observer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_125.png[/img]{Vu que le squelette, sa bière et son pain n\'iront nulle part, vous le laissez tranquille. Cependant, le manche de la hache attire de nouveau votre attention. %observer% se dirige vers la souche et les braises. Il essaie de le retirer mais il n\'a pas de chance, il recule et l\'enfonce davantage. La souche et le manche se brisent en deux et le mercenaire tombe en arrière, le manche traverse le toit du bateau, on peut l\'entendre s\'entrechoquer sur les parois à l\'extérieur. Les débris et la fumée flottent lentement. Le mercenaire se lève et se congratule.%SPEECH_ON%WQu\'est-ce que c\'était que ça ?%SPEECH_OFF%Vous le faites taire tout en le montrant du doigt. Une petite oie dorée s\'installe là où se trouvait la base de la souche. L\'éclat de son métal brille et tournoie. Vous avez entendu des histoires d\'oies dorées, mais vous n\'avez jamais pensé que cela pouvait être authentique!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Est-ce réel?",
					function getResult( _event )
					{
						return "D";
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Observer.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_125.png[/img]{%observer% trébuche en avant.%SPEECH_ON%Monsieur, que faites-vous ?%SPEECH_OFF%Vous lui faites signe de partir et vous ramassez l\'oie d\'or. En la tenant à deux mains, vous ressentez une étrange chaleur. Il n\'explose pas ou ne fait pas fondre votre visage. Vous pouvez sentir son métal onduler très légèrement contre vos doigts. Il pourrait même être en train de grandir ? Le trésor étant bien caché sous votre coude, vous vous demandez pourquoi le squelette ne s\'en est pas mieux sorti. %observer% s\'approche et touche l\'oie dorée sur la tête, mais recule rapidement. Vous demandez si ça l\'a brûlé. Le mercenaire se pince les lèvres.%SPEECH_ON%Vraiment, monsieur? Ce n\'était pas évident?%SPEECH_OFF%Il se met le doigt dans la bouche. Vous lui dites de ne pas être aussi brusque avec son commandant ou vous lui lancerez l\'oie et vous verrez si elle l\'élimine aussi rapidement que le squelette. L\'homme hausse les épaules.%SPEECH_ON%oooh regardez l\'homme qui a été choisi par une babiole brillante, mettez lui une lame sous une aile pour qu\'elle puisse vous adouber, ou alors pourquoi ne pas la mettre sur votre tête et vous déclarer roi?%SPEECH_OFF%Vous regardez l\'oie. Une goutte de sang rouge coule le long de son corps, elle devient dorée et tombe sur le sol dans un petit bruit. Vous la ramassez et la mordez. L\'or passe avec satisfaction entre vos dents et vous le jetez ensuite à %observateur%. Il ne le brûle pas cette fois, et vous réalisez que vous avez peut-être trouvé la véritable Oie d\'or des contes!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Les contes sont vrais!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Observer.getImagePath());
				this.World.Assets.getStash().makeEmptySlots(1);
				local item;
				item = this.new("scripts/items/special/golden_goose_item");
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "Vous recevez " + item.getName()
				});
			}

		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
		local brothers = this.World.getPlayerRoster().getAll();
		local candidates = [];

		foreach( bro in brothers )
		{
			if (!bro.getBackground().isNoble() && !bro.getSkills().hasSkill("trait.bright") && !bro.getSkills().hasSkill("trait.short_sighted") && !bro.getSkills().hasSkill("trait.night_blind"))
			{
				candidates.push(bro);
			}
		}

		if (candidates.len() != 0)
		{
			this.m.Observer = candidates[this.Math.rand(0, candidates.len() - 1)];
		}
		else
		{
			this.m.Observer = brothers[this.Math.rand(0, brothers.len() - 1)];
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"observer",
			this.m.Observer != null ? this.m.Observer.getNameOnly() : ""
		]);
	}

	function onDetermineStartScreen()
	{
		return "A";
	}

	function onClear()
	{
		this.m.Observer = null;
	}

});

